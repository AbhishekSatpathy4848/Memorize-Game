//
//  ViewModel.swift
//  Memorize
//
//  Created by Abhishek Satpathy on 06/03/23.
//

import Foundation

class MemorizeGameViewModel: ObservableObject{
    
    static let cardTimer:Double = 10
    
    static let gameHealth: Int = 20
    
    static let gameHealthPenalty: Int = 5
    
    static var emojis = ["🛳","✈️","🚀","⛵️","🏎","🚞","🛺","🛻","🚝","🛴"]
    
    static func createMemoryGame() -> MemorizeGameModel<String>{
        
        let model = MemorizeGameModel<String>(numberOfPairsOfCards: 10,cardTimer: cardTimer,gameHealth: gameHealth, gameHealthPenalty: 5){index in emojis[index]}
        return model
    }
    
    
    @Published private(set) var model: MemorizeGameModel = createMemoryGame()
    
    // User Intent(s)
    
    func chooseCard(_ card: MemorizeGameModel<String>.Card){
        model.chooseCard(card)
    }
    
//    func addCardPair(){
//        model.addCardPair(content: MemorizeGameViewModel.emojis[6])
//    }
     
    func isGameFinished() -> Bool{
        return model.isGameFinished
    }
    
//    func shuffleCards(){
//        model.shuffleCards()
//    }
    
    func getHealth() -> Int{
        model.getHealth()
    }
    
    func shuffleCards(){
        model.shuffleCards()
    }
    
    func restartGame(){
        model = MemorizeGameViewModel.createMemoryGame()
    }
    
    func setGameLost(){
        model.setGameLost()
    }
    
    func hasLostGame() -> Bool{
        model.lostGame
    }
    
    func cardTimeUp(){
        model.cardTimeUp(drop:5)
    }
//
//    func viewRemainingTime(for card:MemorizeGameModel<String>.Card) -> Double{
//        return card.remainingTimePercentage
//    }
//
//    func viewRemainingTimePercentage(for card:MemorizeGameModel<String>.Card) -> Double{
//        return card.remainingTimePercentage
//    }
//    
}
