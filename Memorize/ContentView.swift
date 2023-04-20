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
        let shape = RoundedRectangle(cornerRadius: DrawingConstants.cardCornerRadius);
            GeometryReader(content: {geometry in
                ZStack{
                    if cardDetails.isFaceUp{
                        shape.fill().foregroundColor(.white)
                        
                        shape.strokeBorder(.red,lineWidth:DrawingConstants.cardBorderLineWidth)
                        
                        Pie(startAngle: Angle(degrees: -90), endAngle: Angle(degrees:180), clockwise: true).padding(10).foregroundColor(Color.red.opacity(0.5))
                        
                        Text(cardDetails.content).font(cardContentFontSize(size: geometry.size))
                    }
                    else if cardDetails.isMatched{
                        shape.opacity(0)
                    }else{
                        shape.foregroundColor(.red)
                    }
                }
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
                
                //                HStack{
                //                    Button(action: {
                ////                        if(emojiCount>1){
                ////                            emojiCount = emojiCount - 1
                //                        }
                //                    }, label: {
                //                        Image(systemName: "minus.circle").font(.largeTitle)
                //                    })
                
                //                    Spacer()
                
                //                    Button(action: {
                //                        if(emojiCount<emojis.count){
                //                            emojiCount = emojiCount + 1
                //                        }
                //                        viewModel.addCardPair()
                //                    }, label: {
                //                        Image(systemName: "plus.circle").font(.largeTitle)
                //                    })
                //                }
                
//                Image(systemName: "shuffle.circle").font(.largeTitle).foregroundColor(.blue).onTapGesture {
//                    viewModel.shuffleCards()
//                }
                
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
    static let cardBorderLineWidth:CGFloat = 3
    static let cardCornerRadius:CGFloat = 15
    
}
