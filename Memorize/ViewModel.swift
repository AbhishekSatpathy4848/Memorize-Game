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
        
        MemorizeGameModel<String>(numberOfPairsOfCards: 5){index in emojis[index]}
    }
    
    @Published private(set) var model: MemorizeGameModel = createMemoryGame()
    
    // User Intent(s)
    
    func chooseCard(_ card: MemorizeGameModel<String>.Card){
        model.chooseCard(card)
    }
    
//    func addCardPair(){
//        model.addCardPair(content: MemorizeGameViewModel.emojis[6])
//    }
     
    
}
