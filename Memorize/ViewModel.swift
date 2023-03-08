//
//  ViewModel.swift
//  Memorize
//
//  Created by Abhishek Satpathy on 06/03/23.
//

import Foundation

class MemorizeGameViewModel: ObservableObject{
    
    static var emojis = ["🛳","✈️","🚀","⛵️","🏎","🚞","🛺","🛻","🚝","🛴"]
    
    static func createMemoryGame() -> MemorizeGameModel<String>{
        
        var model = MemorizeGameModel<String>(numberOfPairsOfCards: 10){index in emojis[index]}
        model.shuffleCards()
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
    
    func getTotalMoves() -> Int{
        model.getTotalMoves()
    }
    
}
