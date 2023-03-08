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
    private var pairsMatched = 0
    private var numberOfPairsOfCards:Int
    private(set) var finishedGame = false
    
    init(numberOfPairsOfCards: Int, content: (Int) -> CardContent) {
        cards = Array<Card>()
        self.numberOfPairsOfCards = numberOfPairsOfCards
        for pairIndex in 0..<numberOfPairsOfCards{
            current_id+=1
            cards.append(Card(id: current_id, content: content(pairIndex)))
            current_id+=1
            cards.append(Card(id: current_id, content: content(pairIndex)))
        }
        current_id+=1
    }
    
    mutating func chooseCard(_ card: Card){
        if let chosenCardIndex = cards.firstIndex(where: {$0.id == card.id}), !cards[chosenCardIndex].isFaceUp, !cards[chosenCardIndex].isMatched{
            if let faceUpCardIndex = onlyFaceUpCardIndex {
                if cards[faceUpCardIndex].content == cards[chosenCardIndex].content {
                    cards[faceUpCardIndex].isMatched = true
                    cards[chosenCardIndex].isMatched = true
                    pairsMatched+=1
                    if(pairsMatched == numberOfPairsOfCards){
                        finishedGame = true
                    }
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
    
    mutating func shuffleCards(){
        for card in cards{
            if card.isFaceUp{
                return
            }
        }
        cards.shuffle()
    }
    
    
    struct Card: Identifiable{
        var id: Int
        var content: CardContent
        var isMatched: Bool = false
        var isFaceUp: Bool = false
    }
}
