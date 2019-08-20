//
//  Concentration.swift
//  concentration
//
//  Created by Echo Wang on 7/22/19.
//  Copyright © 2019 Echo Wang Studio. All rights reserved.
//

import Foundation

//class Concentration
struct Concentration
{
    // creates an empty array
    private(set) var cards = [Card]()
    
    // computed properties
    private var onlyOneCardsFaceUp: Int?{
        get{
            // use closures to simplize the code
            // filters the collection, makes an array out of the ones that return true
            // var faceUpIndices = cards.indices.filter {cards[$0].isFaceUp}
            // return faceUpIndices.count == 1 ? faceUpIndices.first : nil
            return cards.indices.filter {cards[$0].isFaceUp}.oneAndOnly
            
            
            /*
            var foundIndex:Int?
            for index in cards.indices{
                if cards[index].isFaceUp{
                    if foundIndex == nil{
                        foundIndex = index
                    } else {
                        return nil
                    }
                }
            }
            return foundIndex
            */
        }
        // newValue is a special local var
        // set(newValue){
        set {
            for index in cards.indices{
                cards[index].isFaceUp = (index == newValue)
            }
        }
    }
    
    mutating func chooseCards(at index: Int){
        // assert: crash right away and put message on console so someone who pass the wrong argument can see it
        assert(cards.indices.contains(index),"concentration.chooseCards(at\(index):chosen index not in the card")
        if !cards[index].isMatched{
            if let one = onlyOneCardsFaceUp, one != index{
                if cards[one] == cards[index]{
                // if cards[one].identifier == cards[index].identifier{
                    cards[one].isMatched = true
                    cards[index].isMatched = true
                }
                cards[index].isFaceUp = true
                // because computed properties, it will compute every time we ask
                // onlyOneCardsFaceUp = nil
            } else {
                /*
                for flipDownIndex in cards.indices{
                    cards[flipDownIndex].isFaceUp = false
                }
                cards[index].isFaceUp = true
                */
                onlyOneCardsFaceUp = index
            }
        }
    }
    
    init(numberOfPairsOfCards: Int){
        assert(numberOfPairsOfCards > 0,"concentration.init(at\(numberOfPairsOfCards):must have one pair of cards")
        // 0..<numberOfPairsOfCards doesn't include the right
        // 1...numberOfPairsOfCards includes the left and right
        // for indentifier in 1...numberOfPairsOfCards{
        for _ in 1...numberOfPairsOfCards{
            let card = Card()
            // let card = Card(identifier: identifier)
            //⚪️ let matchingCard = Card(identifier: identifier)
            // card is a struct, matchingCard will copy it
            //⚫️ let matchingCard = card
            // array is a struct, it will copy card
            //🔴 cards.append(card)
            //⚪️⚫️🔴 cards.append(card)
            //⚪️⚫️ cards.append(matchingCard)
            
            // cards += [card, card]
            // TODO:shuffle the cards
            var randomIndex = Int(arc4random_uniform(UInt32(cards.count)))
            cards.insert(card, at: randomIndex)
            randomIndex = Int(arc4random_uniform(UInt32(cards.count)))
            cards.insert(card, at: randomIndex)
        }
    }
}

extension Collection{
    var oneAndOnly: Element?{
        // count is a collection method
        // first is a collection method, return the first thing in there
        return count == 1 ? first : nil
    }
}
