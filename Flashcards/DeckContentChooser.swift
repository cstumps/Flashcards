//
//  DeckContentChooser.swift
//  Flashcards
//
//  Created by Jason Hirst on 8/1/24.
//

import SwiftUI

struct DeckContentChooser: View {
    var body: some View {
        NavigationStack {
            deckList
                .navigationTitle("Deck List")
//                .toolbarBackground(.green.opacity(0.2), for: .navigationBar)
//                .toolbarBackground(.visible, for: .navigationBar)
                .navigationDestination(for: DeckContent<String>.ID.self) { deckId in
                    loadDeck(withId: deckId)
                        .navigationBarTitleDisplayMode(.inline)
                }
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Image(systemName: "plus")
                    }
//                    ToolbarItem(placement: .principal) {
//                        Image(systemName: "rectangle.on.rectangle")
//                    }
                    ToolbarItem(placement: .topBarLeading) {
                        Image(systemName: "gearshape")
                    }
                }
        }
    }
    
    var deckList: some View {
        List {
            ForEach(decks) { deck in
                DeckListItem(deck: deck)
            }
        }
    }
}

struct DeckListItem: View {
    var deck: DeckContent<String>
    
    var body: some View {
        NavigationLink(value: deck.id) {
            VStack(alignment: .leading) {
                Text(deck.name).font(.title2)
                Text("\(deck.contentSet.count) cards")
            }
        }
    }
}

@ViewBuilder
private func loadDeck(withId: DeckContent<String>.ID) -> some View {
    if let index = decks.firstIndex(where: { $0.id == withId }) {
        let deck = StringCardDeck(deck: decks[index])
        ContentView(deck: deck)
    }
}

#Preview {
    DeckContentChooser()
}
