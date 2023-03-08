//
//  File.swift
//  Memorize
//
//  Created by Abhishek Satpathy on 06/03/23.
//

import Foundation

struct MemorizeGameModel<CardContent>{
    private(set) var cards: Array<Card>
    private var current_id = 0
    
    mutating func chooseCard(_ card: Card){
        if let index = cards.firstIndex(where: {$0.id == card.id}){
            cards[index].isFaceUp.toggle()
        }
    }
    
//    func index(of card: Card) -> Int{
//        for index in 0..<cards.count{
//            if cards[index].id == card.id{
//                return index
//            }
//        }
//        return -1
//    }
    
    init(numberOfPairsOfCards: Int, content: (Int) -> CardContent) {
        cards = Array<Card>()
        for pairIndex in 1...numberOfPairsOfCards{
            current_id+=1
            cards.append(Card(id: pairIndex*2-1, content: content(pairIndex)))
            current_id+=1
            cards.append(Card(id: pairIndex*2, content: content(pairIndex)))
        }
        current_id+=1
    }
    
    mutating func addCardPair(content: CardContent){
        cards.append(Card(id: current_id, content: content))
        current_id+=1
        cards.append(Card(id: current_id, content: content))
        current_id+=1
    }
    
    
    struct Card: Identifiable{
        var id: Int
        var content: CardContent
        var isMatched: Bool = false
        var isFaceUp: Bool = false
    }
}
