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
        let shape = RoundedRectangle(cornerRadius: 15);
       
        ZStack{
            if cardDetails.isFaceUp{
                shape.fill().foregroundColor(.white)
                
                shape.strokeBorder(.red,lineWidth:3)
                
                Text(cardDetails.content).font(.largeTitle)
            }else{
                shape.foregroundColor(.red)
            }
        }
    }
}


struct ContentView: View {
    
    @ObservedObject var viewModel:MemorizeGameViewModel = MemorizeGameViewModel()
 
    var body: some View {
            VStack{
                ScrollView{
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 70))],spacing: 20.0){
                        ForEach(viewModel.model.cards, content: {card in
                            Card(cardDetails: card).aspectRatio(2/3,contentMode: .fit).padding(.leading, 5.0).onTapGesture {
                                viewModel.chooseCard(card)
                            }
                        })
                    }
                }
                
                Spacer()
                
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
            }.padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().preferredColorScheme(.dark)
    }
}
