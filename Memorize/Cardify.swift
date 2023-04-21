//
//  File.swift
//  Memorize
//
//  Created by Abhishek Satpathy on 21/04/23.
//

import SwiftUI

struct Cardify: ViewModifier{
    var isFaceUp:Bool
    var isMatched:Bool
    
    func body(content: Content) -> some View {
        ZStack{
            let shape = RoundedRectangle(cornerRadius: DrawingConstants.cardCornerRadius);
            if isFaceUp{
                shape.fill().foregroundColor(.white)
                shape.strokeBorder(.red,lineWidth:DrawingConstants.cardBorderLineWidth)
                
            }else{
                shape.fill().foregroundColor(isMatched ? .white : .red)
            }
//            content.opacity(isMatched || !isFaceUp ? 0:1)
            content.opacity(isFaceUp ? 1 : 0)
        }
    }
    
}

private struct DrawingConstants{
    static let cardCornerRadius:CGFloat = 15
    static let cardBorderLineWidth:CGFloat = 3
}

extension View{
    func cardify(isFaceUp:Bool,isMatched:Bool) -> some View{
        return self.modifier(Cardify(isFaceUp: isFaceUp, isMatched: isMatched))
    }
}
