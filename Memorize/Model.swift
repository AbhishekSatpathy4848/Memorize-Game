//
//  File.swift
//  Memorize
//
//  Created by Abhishek Satpathy on 06/03/23.
//

import Foundation

struct MemorizeGameModel<CardContent> where CardContent: Equatable{
    private(set) var cards: Array<Card>
    private var current_card_id = 0
    private var onlyFaceUpCardIndex:Int? {
        get {cards.indices.filter{cards[$0].isFaceUp}.onlyOneElement}
        set{cards.indices.forEach{cards[$0].isFaceUp = ($0 == newValue)}}
    }
    private var pairsMatched = 0
    private var numberOfPairsOfCards:Int
    private(set) var isGameFinished = false
    private(set) var totalMoves = 0
    
    init(numberOfPairsOfCards: Int, content: (Int) -> CardContent) {
        cards = Array<Card>()
        self.numberOfPairsOfCards = numberOfPairsOfCards
        for pairIndex in 0..<numberOfPairsOfCards{
            current_card_id+=1
            cards.append(Card(id: current_card_id, content: content(pairIndex)))
            current_card_id+=1
            cards.append(Card(id: current_card_id, content: content(pairIndex)))
        }
        current_card_id+=1
    }
     
    mutating func chooseCard(_ card: Card){
        if let chosenCardIndex = cards.firstIndex(where: {$0.id == card.id}), !cards[chosenCardIndex].isFaceUp, !cards[chosenCardIndex].isMatched{
            totalMoves+=1
            if let faceUpCardIndex = onlyFaceUpCardIndex {
                if cards[faceUpCardIndex].content == cards[chosenCardIndex].content {
                    cards[faceUpCardIndex].isMatched = true
                    cards[chosenCardIndex].isMatched = true
                    pairsMatched+=1
                    if(pairsMatched == numberOfPairsOfCards){
                        isGameFinished = true
                    }
                }
                cards[chosenCardIndex].isFaceUp.toggle()
            }else{
                onlyFaceUpCardIndex = chosenCardIndex
            }
        }
    }
    
    mutating func addCardPair(content: CardContent){
        cards.append(Card(id: current_card_id, content: content))
        current_card_id+=1
        cards.append(Card(id: current_card_id, content: content))
        current_card_id+=1
    }
    
    mutating func shuffleCards(){
        for card in cards{
            if card.isFaceUp{
                return
            }
        }
        cards.shuffle()
    }
    
    func getTotalMoves() -> Int{
        totalMoves
    }
    
    
    struct Card: Identifiable{
        var id: Int
        var content: CardContent
        var isMatched: Bool = false
        var isFaceUp: Bool = false
    }
}

extension Array{
    var onlyOneElement: Element? {
        if self.count == 1{
            return self.first
        }else{
            return nil
        }
    }
}
