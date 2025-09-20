//
//  ContentView.swift
//  Flashcards
//
//  Created by Jason Hirst on 7/22/24.
//

import SwiftUI

// TODO:  Colors and such should be part of the 'theme' or deck or whatever we want to call it
// TODO:  Allow colors for text / card color.  May need opacity so color isn't overwhelming.
// TODO:  Let user select font as well for a given deck

struct ContentView: View {
    @ObservedObject var deck: StringCardDeck
    
    @State private var sheetShown = false
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Title").font(.title)
            Text("Cards in deck").padding(.bottom)
            
            ScrollView {
                ForEach(deck.cards) { card in
                    CardView(card)
                        .aspectRatio(1.7, contentMode: .fill)
                        .onTapGesture {
                            withAnimation(.easeInOut/*(duration: 3)*/) { deck.flip(card) }
                        }
                        .transition(.push(from: .leading))
                        .gesture(DragGesture(minimumDistance: 3.0, coordinateSpace: .local)
                            .onEnded { _ in
                                withAnimation(.easeInOut) {
                                    deck.replace(card)
                                }
                            })
                }
            }
            .scrollClipDisabled()
            .frame(maxWidth: .infinity)
            Button("Test") {
                sheetShown.toggle()
            }
            .sheet(isPresented: $sheetShown) {
                let allFontNames = UIFont.familyNames.flatMap { UIFont.fontNames(forFamilyName: $0)}
            
                List(allFontNames, id: \.self) { name in
                    Text(name)
                        .font(Font.custom(name, size: 12))
                }
            }
        }
        .padding(.horizontal)
    }
}

struct CardView: View, Animatable {
    let card: StringCardDeck.Card
    var rotation: Double // In degrees
    
    var animatableData: Double {
        get { rotation }
        set { rotation = newValue }
    }
    
    init(_ card: StringCardDeck.Card) {
        self.card = card
        rotation = card.isFrontUp ? 0 : 180
    }
    
    var body: some View {
        ZStack {
            let shape = RoundedRectangle(cornerRadius: 30)
            
            shape.fill()
                .foregroundColor(.white)
                .shadow(color: .gray, radius: 2, x: 0, y: 1)
            
            shape.strokeBorder(lineWidth: 3)
            
            if rotation < 90 {
                Text(try! AttributedString(markdown: card.front))
                    .opacity(rotation < 90 ? 1 : 0)
            } else {
                Text(try! AttributedString(markdown: card.back))
                    .opacity(rotation < 90 ? 0 : 1)
                    .scaleEffect(CGSize(width: 1.0, height: -1.0))
            }
        }
        .rotation3DEffect(Angle.degrees(rotation), axis: (1, 0, 0))
    }
}

#Preview {
    DeckContentChooser()
}
