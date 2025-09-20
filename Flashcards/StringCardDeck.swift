//
//  StringCardDeck.swift
//  Flashcards
//
//  Created by Jason Hirst on 7/22/24.
//

import SwiftUI

var decks = [
    DeckContent(name: "Deck 1", color: RGBA(color: .green), contentSet: [(front: "Card 1\n**Front**\nDeck 1", back: "Card 1\nBack\nDeck 1"),
                                                                         (front: "Card 2\n**Front**\nDeck 1", back: "Card 2\nBack\nDeck 1"),
                                                                         (front: "Card 3\n**Front**\nDeck 1", back: "Card 3\nBack\nDeck 1"),
                                                                         (front: "Card 4\n**Front**\nDeck 1", back: "Card 4\nBack\nDeck 1"),
                                                                         (front: "Card 5\n**Front**\nDeck 1", back: "Card 5\nBack\nDeck 1")]),
    
    DeckContent(name: "Deck 2", color: RGBA(color: .blue), contentSet: [(front: "Card 1\nFront\nDeck 2", back: "Card 1\nBack\nDeck 2"),
                                                                        (front: "Card 2\nFront\nDeck 2", back: "Card 2\nBack\nDeck 2"),
                                                                        (front: "Card 3\nFront\nDeck 2", back: "Card 3\nBack\nDeck 2"),
                                                                        (front: "Card 4\nFront\nDeck 2", back: "Card 4\nBack\nDeck 2"),
                                                                        (front: "Card 5\nFront\nDeck 2", back: "Card 5\nBack\nDeck 2")])
]

class StringCardDeck: ObservableObject {
    typealias Card = CardDeck<String>.Card
    
    @Published private(set) var model: CardDeck<String>
    
    private var deck: DeckContent<String>
    private var cardOrder: [Int] = []
    
    var cards: Array<Card> {
        return model.cardsInPlay.sorted {
            cardOrder.firstIndex(of: $0.id)! < cardOrder.firstIndex(of: $1.id)!
        }
    }

    init(deck: DeckContent<String>) {
        self.deck = deck
        model = StringCardDeck.createCardDeck(deck: deck)
        
        model.draw()
        model.draw()
        model.draw()
        //model.draw()
        
        // Later this will not be cardsInPlay.count but rather the number of visible cards as dictated by settings.  If the number is changed mid game, we have to regenerate the cardOrder array so it's the correct size
        for index in 0..<model.cardsInPlay.count {
            cardOrder.append(model.cardsInPlay[index].id)
        }
    }
    
    private static func createCardDeck(deck: DeckContent<String>) -> CardDeck<String> {
        return CardDeck<String>(numberOfCards: deck.contentSet.count) { index in
            deck.contentSet[index]
        }
    }
    
    // MARK: - Intents
    
    func flip(_ card: Card) {
        model.flip(card)
    }
    
    func replace(_ card: Card) {
        // Draw the next card
        if let newCard = model.draw(),
           let index = cardOrder.firstIndex(of: card.id) {
                cardOrder[index] = newCard.id
        }
        
        // Discard the current card
        model.discard(card)
    }
}
