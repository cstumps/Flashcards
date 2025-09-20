//
//  CardDeck.swift
//  Flashcards
//
//  Created by Jason Hirst on 7/22/24.
//

import Foundation

struct CardDeck<CardContent> {
    private var cards: Array<Card>
    
    var cardsInPlay: Array<Card> {
        cards.filter({ $0.state == .inPlay })
    }
    
    init(numberOfCards: Int, createCardContent: (Int) -> (front: CardContent, back: CardContent)) {
        cards = []
        
        for index in 0..<numberOfCards {
            let content = createCardContent(index)
            cards.append(Card(id: index, front: content.front, back: content.back))
        }
        
        cards.shuffle()
    }
    
    mutating func flip(_ card: Card) {
        if let cardIndex = cards.firstIndex(where: { $0.id == card.id }) {
            cards[cardIndex].isFrontUp.toggle()
        }
    }
    
    mutating func discard(_ card: Card) {
        if let cardIndex = cards.firstIndex(where: { $0.id == card.id }) {
            cards[cardIndex].state = .discarded
        }
    }
    
    @discardableResult
    mutating func draw() -> Card? {
        if let cardIndex = cards.firstIndex(where: { $0.state == .unDrawn }) {
            cards[cardIndex].state = .inPlay
            return cards[cardIndex]
        } else {
            return nil
        }
    }
    
    struct Card: Identifiable {
        let id: Int
        
        let front: CardContent
        let back: CardContent
        
        var isFrontUp = true
        var state: CardState = .unDrawn

        enum CardState {
            case unDrawn, inPlay, discarded
        }
    }
}
