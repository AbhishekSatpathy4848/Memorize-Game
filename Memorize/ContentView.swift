//
//  ContentView.swift
//  Memorize
//
//  Created by Abhishek Satpathy on 02/03/23.
//

import SwiftUI

struct Card: View{
    var cardDetails: MemorizeGameModel<String>.Card
    
    var body: some View{
            GeometryReader(content: {geometry in
                ZStack{
                    Pie(startAngle: Angle(degrees: -90), endAngle: Angle(degrees:180), clockwise: true).padding(10).foregroundColor(Color.red.opacity(0.5))
                    
                    Text(cardDetails.content).font(cardContentFontSize(size: geometry.size))
                }.cardify(isFaceUp: cardDetails.isFaceUp, isMatched: cardDetails.isMatched)
            })
    }
    
    func cardContentFontSize(size: CGSize) -> Font {
        Font.system(size: size.width * DrawingConstants.cardContentScalingFactor)
    }
}



struct ContentView: View {
    
    @ObservedObject var viewModel:MemorizeGameViewModel
 
    var body: some View {
        if !viewModel.isGameFinished(){
            VStack{
                ScrollView{
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: UIScreen.main.bounds.size.width/6))],spacing: 10.0){
                        ForEach(viewModel.model.cards, content: {card in
                            Card(cardDetails: card).aspectRatio(2/3,contentMode: .fit).onTapGesture {
                                viewModel.chooseCard(card)
                            }
                        })
                    }
                }
                
                
                Spacer()
                
                Text("Score: \(viewModel.getTotalMoves())").font(.largeTitle)
                
            }.padding()
        }else{
            VStack{
                Text("Wohooo!! Game Completed").font(.largeTitle)
                Text("Score: \(viewModel.getTotalMoves())").font(.largeTitle)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(viewModel: MemorizeGameViewModel()).preferredColorScheme(.light)
    }
}

private struct DrawingConstants{
    static let cardContentScalingFactor = 0.5
}
