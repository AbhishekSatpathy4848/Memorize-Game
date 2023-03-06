//
//  File.swift
//  Memorize
//
//  Created by Abhishek Satpathy on 06/03/23.
//

import Foundation

struct MemorizeGameModel<CardContent>{
    private(set) var cards: Array<Card>
    
    init(numberOfPairsOfCards: Int, content: (Int) -> CardContent) {
        cards = Array<Card>()
        for pairIndex in 1...numberOfPairsOfCards{
            cards.append(Card(content: content(pairIndex)))
            cards.append(Card(content: content(pairIndex)))
        }
    }
    
    struct Card{ 
        var content: CardContent
        var isMatched: Bool = false
        var isFaceUp: Bool = false
    }
}
