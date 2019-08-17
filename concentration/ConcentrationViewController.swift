//
//  ViewController.swift
//  concentration
//
//  Created by Echo Wang on 7/21/19.
//  Copyright © 2019 Echo Wang Studio. All rights reserved.
//

import UIKit

//UIViewController is in UIKit
class ConcentrationViewController: UIViewController {
    
    // class gets a free init if vars in class have been initialized
    // lazy: it doesn't actually initialize until someone tries to use it, can't have didSet
    // private: only callable from within this object
    private lazy var game = Concentration(numberOfPairsOfCards: numberOfPairsOfCards)
    
    // computed properties
    var numberOfPairsOfCards: Int{
        // no set: read only
            return (cardButtons.count+1) / 2
    }
    
    
    // should initialize instance variables by = or by init
    // private(set): is readable outside this object, but not settable
    private(set) var flipCount = 0{
        // property observer: execute when flipCount changes
        // when flipcount = 0, not call didSet
        didSet{
            updateFlipCountLabel()
        }
    }

    private func updateFlipCountLabel(){
        // use NSAttributedString
        // flipCountLabel.text = "flips:\(flipCount)"
        let attribute:[NSAttributedString.Key:Any] = [
            .strokeWidth: 5.0,
            .strokeColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        ]
        let attributedString = NSAttributedString(string:"flips:\(flipCount)" , attributes: attribute)
        flipCountLabel.attributedText = attributedString
    }
    
    // always have private outlets and actions which are internal implementations
    @IBOutlet private weak var flipCountLabel: UILabel!{
        // when ios make connection, it calls didSet
        didSet{
            updateFlipCountLabel()
        }
    }
    
    // [UIButton] = Array<UIButton>
    @IBOutlet private var cardButtons: [UIButton]!
    
    // MARK: handle card touch behavior
    // var emojiChoices = ["👻","🎃","👻","🎃"]
    
    // IBAction and IBOutlet is a special directive that xcode is putting in here to get the circle on the left
    // click the circle will show which button send this message
    // @IBAction func touchCard(_ sender: UIButton) -> Int to indicate the return value type
    // use _ as external name because it's from oc which doesn't have external and internal name
    @IBAction private func touchCard(_ sender: UIButton){
        flipCount += 1
        // let = const
        // .firstIndex return -> Int? means optional
        // optional : set or not set, each case can associate with data
        // nil always means an optional that is not set
        if let cardNumber = cardButtons.firstIndex(of: sender){
            //print("\(cardNumber)")
            //flipCard(withEmoji: emojiChoices[cardNumber], on: sender)
            game.chooseCards(at: cardNumber)
            updateViewFromModel()
        }else{
            print("chosen card was not in cardbuttons")
        }
    }
    
    private func updateViewFromModel(){
        if cardButtons != nil{
            for index in cardButtons.indices{
                let button = cardButtons[index]
                let card = game.cards[index]
                if card.isFaceUp{
                    button.setTitle(emoji(for: card), for: UIControl.State.normal)
                    button.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
                } else {
                    button.setTitle("", for: UIControl.State.normal)
                    button.backgroundColor = card.isMatched ? #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0) : #colorLiteral(red: 0.2352941176, green: 0.7058823529, blue: 0.9803921569, alpha: 1)
                }
            }
        }
    }
    
    var theme: String?{
        didSet{
            emojiChoices = theme ?? ""
            // reset, because it might be from different theme, swift can infer the type
            emoji = [:]
            // if someone sets the theme when it's in middle game
            updateViewFromModel()            
        }
    }
    
    // private var emojiChoices = ["🤡","🎃","👻","🐽","🐸","🍒","💧"]
    // use string
    private var emojiChoices = "😱😈🤡🎃👻🕸🍬🍭"
    
    // var emoji = Dictionary<Int,String>()
    // private var emoji = [Int:String]()
    // put card as key
    private var emoji = [Card:String]()
    
    private func emoji(for card: Card) -> String {
        /*
        // put emoji in dictionary on demand
        if emoji[card.identifier] == nil, emojiChoices.count > 0 {
                // use extension to get rid of this messy code
                // let randomIndex = Int(arc4random_uniform(UInt32(emojiChoices.count)))
                // emoji[card.identifier] = emojiChoices.remove(at: randomIndex)
                emoji[card.identifier] = emojiChoices.remove(at: emojiChoices.count.arc4random)
        }
        /*
        // looking up something in dictionary returns an optional
        if emoji[card.identifier] != nil{
            return emoji[card.identifier]!
        } else {
            return "?"
        }
        */
        return emoji[card.identifier] ?? "?"
        */
        
        // get rid of .identifier, put card directly into dictionaries
        if emoji[card] == nil, emojiChoices.count > 0 {
            let randomStringIndex = emojiChoices.index(emojiChoices.startIndex, offsetBy: emojiChoices.count.arc4random)
            // string is a collection of character, so .remove returns character, but dictionaries accept string
            emoji[card] = String(emojiChoices.remove(at: randomStringIndex))
            // emoji[card] = emojiChoices.remove(at: emojiChoices.count.arc4random)
        }
        return emoji[card] ?? "?"
            
        
    }
    
    /*
    @IBAction func touchCard(_ sender: UIButton){
        // print("ghost")
        flipCount += 1
        //flipCountLabel.text = "flips:\(flipCount)"
        flipCard(withEmoji : "👻", on: sender)
    }
    
    // when copy UI, pay attention to the connection is also copied
    @IBAction func touchSecondCard(_ sender: UIButton) {
        flipCount += 1
        //flipCountLabel.text = "flips:\(flipCount)"
        flipCard(withEmoji : "🎃", on: sender)
    }
    */
    
    /*
    // external name "with Emoji"
    // internal name "emoji"
    // so when call it, reads like flipcard withemoji "" on ""
    func flipCard(withEmoji emoji:String, on button:UIButton){
        // print("\(emoji)")
        if button.currentTitle == emoji{
            button.setTitle("", for: UIControl.State.normal)
            button.backgroundColor = #colorLiteral(red: 1, green: 0.5781051517, blue: 0, alpha: 1)
        } else {
            button.setTitle(emoji, for: UIControl.State.normal)
            button.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        }
    }
    */
}

extension Int{
    var arc4random:Int{
        if self > 0 {
        // self is int
            return Int(arc4random_uniform(UInt32(self)))
        } else if self < 0 {
            return -Int(arc4random_uniform(UInt32(abs(self))))
        } else {
            return 0
        }
    }
}
