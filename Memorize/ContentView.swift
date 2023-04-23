//
//  ContentView.swift
//  Memorize
//
//  Created by Abhishek Satpathy on 02/03/23.
//

import SwiftUI

struct Card: View{
    var viewModel:MemorizeGameViewModel
    var cardDetails: MemorizeGameModel<String>.Card
    @State var animatedRemainingTime: Double = 0
//    @State private var animatedRemainingTime:Double = 0
    
    
    var body: some View{
            GeometryReader(content: {geometry in
                ZStack{
                    if cardDetails.isFaceUp && !cardDetails.isMatched{
                        Pie(startAngle: Angle(degrees: -90), endAngle: Angle(degrees:(animatedRemainingTime/MemorizeGameViewModel.cardTimer)*360-90), clockwise: true).padding(10).foregroundColor(Color.red.opacity(0.5)).onAppear{
                            //                        print("inside card \(cardDetails.id)")
//                            print("Inside Card \(remainingTime)")
                            //                        animatedRemainingTime = remainingTime
                            //                        let timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
                            //                            print("Timer fired!")
                            //                        }
                            //                        print("remaining \(remainingTime)")
                            print("Appeared on \(cardDetails.content) with time \(cardDetails.remainingTime) isMatched \(cardDetails.isMatched)")
                            animatedRemainingTime = cardDetails.remainingTime
//                            print("remaining \(cardDetails.content)  \(cardDetails.remainingTime/MemorizeGameViewModel.cardTimer)")
//                            let timer = Timer.scheduledTimer(withTimeInterval: cardDetails.remainingTime, repeats: true) { timer in
//                                if (animatedRemainingTime/MemorizeGameViewModel.cardTimer)*360-90 <= 0 && !cardDetails.isMatched{
//                                    viewModel.setGameLost()
//                                }
                                    

//                           }
                            withAnimation(Animation.linear(duration: cardDetails.remainingTime)){
                                animatedRemainingTime = 0
                                
                            }
                        }
                    }
                    
                    Text(cardDetails.content)
//                        .rotationEffect(Angle(degrees: cardDetails.isMatched && cardDetails.isFaceUp ? 360 : 0))
//                        .animation(Animation.linear(duration: 1).repeatForever(autoreverses: false))
                        .font(cardContentFontSize(size: geometry.size))
                }.cardify(isFaceUp: cardDetails.isFaceUp, isMatched: cardDetails.isMatched)
            })
    }
    
    func cardContentFontSize(size: CGSize) -> Font {
        Font.system(size: size.width * DrawingConstants.cardContentScalingFactor)
    }
}



struct ContentView: View {
    
    @ObservedObject var viewModel:MemorizeGameViewModel
    @State var dealtCards:Set<Int> = Set<Int>()
    @Namespace private var dealingCardNameSpace
    
//    @State var haveDealtCards:Bool = false
    
    private func dealCard(_ card:MemorizeGameModel<String>.Card){
        dealtCards.insert(card.id)
    }
    
    private func isDealt(_ card:MemorizeGameModel<String>.Card) -> Bool{
        dealtCards.contains(card.id)
    }
 
    
    private func calculateDealDuration(_ card:MemorizeGameModel<String>.Card) -> Animation{
        var delay:Double = 0;
        if let index = viewModel.model.cards.firstIndex(where: {$0.id == card.id}){
            delay = Double(index) / 10;
        }
        return Animation.easeIn.delay(delay)
    }
    
    private func calculatezIndex(_ card:MemorizeGameModel<String>.Card) -> Double{
        if let index = viewModel.model.cards.firstIndex(where: {
            $0.id == card.id
        }){
            return -Double(index)
        }
        return 0
    }

    
    var deck:some View{
        ZStack{
            ForEach(viewModel.model.cards.filter({isDealt($0)==false})){card in
                Card(viewModel:viewModel,cardDetails: card).matchedGeometryEffect(id: card.id, in: dealingCardNameSpace).zIndex(calculatezIndex(card)).frame(width: 120,height:180)
//                    .transition(AnyTransition.asymmetric(insertion: .opacity, removal: .identity))
            }
        }.onTapGesture {
                    for card in viewModel.model.cards{
                        withAnimation(calculateDealDuration(card)){
                            dealCard(card)
                        }
                    }
//            haveDealtCards = true
                            
        }
    }
    

    var body: some View {
        if !viewModel.isGameFinished() && !viewModel.hasLostGame(){
            ZStack(alignment: .bottom){
                VStack{
                    ScrollView{
                        LazyVGrid(columns: [GridItem(.adaptive(minimum: UIScreen.main.bounds.size.width/6))],spacing: 15.0){
                            ForEach(viewModel.model.cards, content: {card in
                                if(isDealt(card) == false){
                                    Color.clear
                                }
                                else{
                                    Card(viewModel: viewModel, cardDetails: card).padding(4).aspectRatio(2/3,contentMode: .fit)
                                        .matchedGeometryEffect(id: card.id, in: dealingCardNameSpace)
                                    //                                    .transition(AnyTransition.asymmetric(insertion: .scale.animation(Animation.easeIn(duration: 10)), removal: .slide).animation(.easeOut))
                                    
                                        .onTapGesture {
                                            withAnimation(Animation.easeOut(duration: 0.4)){
                                                viewModel.chooseCard(card)
                                            }
                                        }
                                }
                            })
                        }
                    }
                    
                    
                    
                    
                    HStack{
//                        Spacer()
                        restartButton
                        
                        Spacer()
                        Text("Health: \(viewModel.getHealth())").font(Font.system(size: 26))
                        Spacer()
                        Button("Shuffle", action: {
                            withAnimation{
                                viewModel.shuffleCards()
                            }
                        }).font(Font.system(size: 30))
//                        Spacer()
                    }
//                    }
                }
                deck
            }.padding()

        }else if viewModel.hasLostGame(){
            VStack{
                Text("Game Over!!").font(.largeTitle)
                
                restartButton.padding(EdgeInsets(top: 40, leading: 0, bottom: 0, trailing: 0))
            }
        }
        else{
            VStack{
                Text("Wohooo!! Game Completed").font(.largeTitle)
                Text("Remaining Health: \(viewModel.getHealth())").font(.largeTitle)
                
                restartButton.padding(EdgeInsets(top: 40, leading: 0, bottom: 0, trailing: 0))
            }
        }
    }
    var restartButton: some View{
        Button("Restart", action: {
            withAnimation{
                dealtCards = []
                viewModel.restartGame()
            }
        }).font(Font.system(size: 30))
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
