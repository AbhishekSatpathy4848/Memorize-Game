//
//  File.swift
//  Memorize
//
//  Created by Abhishek Satpathy on 06/03/23.
//

import Foundation

struct MemorizeGameModel<CardContent> where CardContent: Equatable{
    private(set) var cards: Array<Card>
    private var current_id = 0
    private var onlyFaceUpCardIndex:Int?
    
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
    
    mutating func chooseCard(_ card: Card){
        
        if let chosenCardIndex = cards.firstIndex(where: {$0.id == card.id}), !cards[chosenCardIndex].isFaceUp, !cards[chosenCardIndex].isMatched{
            if let faceUpCardIndex = onlyFaceUpCardIndex {
                if cards[faceUpCardIndex].content == cards[chosenCardIndex].content {
                    cards[faceUpCardIndex].isMatched = true
                    cards[chosenCardIndex].isMatched = true
                }
                onlyFaceUpCardIndex = nil
            }else{
                for index in 0..<cards.count{
                    cards[index].isFaceUp = false
                }
                onlyFaceUpCardIndex = chosenCardIndex
            }
            cards[chosenCardIndex].isFaceUp.toggle()
        }
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
