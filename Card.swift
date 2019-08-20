//
//  Card.swift
//  concentration
//
//  Created by Echo Wang on 7/22/19.
//  Copyright © 2019 Echo Wang Studio. All rights reserved.
//

import Foundation

// struct vs class
// 1️⃣struct has no inheritance
// 2️⃣structs are value types(it is copied) and classes are reference types
// arrays, ints, strings, dictionaries are structs
// copy-on-write:swift actual copies when someone modifies it
// reference type: thing lives in heap, you got pointers to it
// struct Card
struct Card: Hashable
{
    // implement the hashble and equatable
    static func ==(lhs:Card, rhs:Card) -> Bool{
        return lhs.identifier == rhs.identifier
    }
    
    func hash(into hasher: inout Hasher){
        hasher.combine(identifier)
    }
    
    
    var isFaceUp = false
    var isMatched = false
    private var identifier: Int
    
    // stored with type not with each individual card
    private static var identifierFactory = 0
    
    // static: ask the type it self
    private static func getUniqueIdentifier() -> Int{
        //Card.identifierFactory += 1
        //return Card.identifierFactory
        // in static func: can work without card.identifierFactory
        identifierFactory += 1
        return identifierFactory
    }

    // init tends to have same external and internal name
    /*
     init(identifier: Int){
     self.identifier = identifier
     }
     */
    
    init(){
        // static: ask the type it self
        self.identifier = Card.getUniqueIdentifier()
    }
}
