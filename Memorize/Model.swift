//
//  File.swift
//  Memorize
//
//  Created by Abhishek Satpathy on 06/03/23.
//

import Foundation

struct MemorizeGameModel<CardContent> where CardContent: Equatable{
    private(set) var cards: Array<Card>
//    private(set) var remainingCardTime: Array<Double?>
    private(set) var firstFaceUpCardStartTime: Date?
    private(set) var firstFaceUpCardIndex: Int?
    private(set) var secondFaceUpCardStartTime: Date?
    private(set) var secondFaceUpCardIndex: Int?
    private var current_card_id = 0
    private var onlyFaceUpCardIndex:Int? {
        get {cards.indices.filter{cards[$0].isFaceUp}.onlyOneElement}
        set{cards.indices.forEach{cards[$0].isFaceUp = ($0 == newValue)}}
    }
    private var pairsMatched = 0
    private var numberOfPairsOfCards:Int
    private var cardTimer:Double
    private var gameHealth:Int
    private var gameHealthPenalty:Int
    private(set) var isGameFinished = false
    private(set) var lostGame = false
//    private(set) var totalMoves = 0
    
    
    init(numberOfPairsOfCards: Int,cardTimer:Double,gameHealth: Int,gameHealthPenalty: Int, content: (Int) -> CardContent) {
        cards = Array<Card>()
        self.numberOfPairsOfCards = numberOfPairsOfCards
        for pairIndex in 0..<numberOfPairsOfCards{
            current_card_id+=1
            cards.append(Card(id: current_card_id, content: content(pairIndex),remainingTime:cardTimer))
            current_card_id+=1
            cards.append(Card(id: current_card_id, content: content(pairIndex),remainingTime:cardTimer))
        }
        current_card_id+=1
        self.cardTimer = cardTimer
        self.gameHealth = gameHealth
        self.gameHealthPenalty = gameHealthPenalty
//        remainingCardTime = Array(repeating: cardTimer, count: numberOfPairsOfCards*2)
//        startCardDateTime = Array(repeating: nil, count: numberOfPairsOfCards*2)
//        lastCardDateTime = Array(repeating: nil, count: numberOfPairsOfCards*2)
    }
     
    mutating func chooseCard(_ card: Card){
        if let chosenCardIndex = cards.firstIndex(where: {$0.id == card.id}), !cards[chosenCardIndex].isFaceUp, !cards[chosenCardIndex].isMatched{
            if let faceUpCardIndex = onlyFaceUpCardIndex {
                if cards[faceUpCardIndex].content == cards[chosenCardIndex].content {
                    cards[faceUpCardIndex].isMatched = true
                    cards[chosenCardIndex].isMatched = true
                    pairsMatched+=1
                    if(pairsMatched == numberOfPairsOfCards){
                        isGameFinished = true
                    }
//                    remainingCardTime[faceUpCardIndex] = nil
//                    remainingCardTime[chosenCardIndex] = nil
                    firstFaceUpCardStartTime = nil
                    firstFaceUpCardIndex = nil
                    secondFaceUpCardStartTime = nil
                    secondFaceUpCardIndex = nil
                    
                }else{
                    secondFaceUpCardStartTime = Date()
//                    print("secondFaceUpCardStartTime \(secondFaceUpCardStartTime)")
                    secondFaceUpCardIndex = chosenCardIndex
                    gameHealth-=1;
                    if(gameHealth<=0){
                        lostGame = true
                    }
//                    print("secondFaceUpCardIndex \(chosenCardIndex)")
                }
                cards[chosenCardIndex].isFaceUp.toggle()
                
//                print("card id \(card.id) remaining time \(cards)")
                
            }else{
                if(firstFaceUpCardStartTime != nil){
                    
                    
                    updateRemainingTime(index: firstFaceUpCardIndex!, startTime: firstFaceUpCardStartTime!)
                    updateRemainingTime(index: secondFaceUpCardIndex!, startTime: secondFaceUpCardStartTime!)
                    
                    
                    
//                    print("remaining time \(cards[firstFaceUpCardIndex!].remainingTime)")
                    
                    
//                    print("remaining time \(cards[secondFaceUpCardIndex!].remainingTime)")
                    
//                    print("card id \(card.id) remaining time \(cards)")
                    
                    
                }
                onlyFaceUpCardIndex = chosenCardIndex
                firstFaceUpCardIndex = onlyFaceUpCardIndex
//                print("onlyfaceupcard \(onlyFaceUpCardIndex)")
                firstFaceUpCardStartTime = Date()
//                print("firstFaceUpCardStartTime \(firstFaceUpCardStartTime)")
//                print("\(remainingCardTime)")
            }
        }
    }
    
//    mutating func addCardPair(content: CardContent){
//        cards.append(Card(id: current_card_id, content: content))
//        current_card_id+=1
//        cards.append(Card(id: current_card_id, content: content))
//        current_card_id+=1
//    }
//
    mutating func shuffleCards(){
        for card in cards{
            if card.isFaceUp{
                return
            }
        }
        cards.shuffle()
    }
    
    func getHealth() -> Int{
        gameHealth
    }
    
    mutating func setGameLost(){
        lostGame = true
    }
    
    mutating func cardTimeUp(drop:Int){
        gameHealth-=drop
        if(gameHealth<=0){
            lostGame = true
        }
    }
    
    mutating func updateRemainingTime(index: Int, startTime: Date){
        var diff = Calendar.current.dateComponents([.minute,.second,.nanosecond], from:startTime,to:  Date())

        cards[index].remainingTime = cards[index].remainingTime - (Double(diff.second!) + pow(10,-9)*Double(diff.nanosecond!))
        if (cards[index].remainingTime<=0) {
            cardTimeUp(drop: gameHealthPenalty)
        }
    }
    
    
    struct Card: Identifiable{
        var id: Int
        var content: CardContent
        var isMatched = false
        var isFaceUp = false
        var remainingTime: Double
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
