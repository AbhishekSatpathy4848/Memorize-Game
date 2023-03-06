//
//  ViewModel.swift
//  Memorize
//
//  Created by Abhishek Satpathy on 06/03/23.
//

import Foundation

class MemorizeGameViewModel{
    
    static var emojis = ["🛳","✈️","🚀","⛵️","🏎","🚞","🛺","🛻","🚝","🛴"]
    
    static func createMemoryGame() -> MemorizeGameModel<String>{
        MemorizeGameModel<String>(numberOfPairsOfCards: 20){index in emojis[index]}
    }
    
    private var model: MemorizeGameModel = createMemoryGame();
    
    
}
