//
//  File.swift
//  Memorize
//
//  Created by Abhishek Satpathy on 21/04/23.
//

import SwiftUI

struct Cardify: AnimatableModifier{
    var isFaceUp:Bool
    var isMatched:Bool
    var rotation:Double
    
    var animatableData: Double {
        get{rotation}
        set{rotation = newValue}
    }
    
    init(isFaceUp: Bool, isMatched: Bool) {
        self.isFaceUp = isFaceUp
        self.isMatched = isMatched
        rotation = isFaceUp ? 0 : 180
    }
    
    func body(content: Content) -> some View {
        ZStack{
            let shape = RoundedRectangle(cornerRadius: DrawingConstants.cardCornerRadius);
            if rotation<90{
                shape.fill().foregroundColor(.white)
                shape.strokeBorder(.red,lineWidth:DrawingConstants.cardBorderLineWidth)
                
            }else{
                shape.fill().foregroundColor(isMatched ? .white : .red)
            }
            content.opacity(rotation<90 ? 1 : 0)
        }.rotation3DEffect(Angle(degrees: rotation), axis: (0,1,0))
    }
    
}

private struct DrawingConstants{
    static let cardCornerRadius:CGFloat = 15
    static let cardBorderLineWidth:CGFloat = 6
}

extension View{
    func cardify(isFaceUp:Bool,isMatched:Bool) -> some View{
        return self.modifier(Cardify(isFaceUp: isFaceUp, isMatched: isMatched))
    }
}
