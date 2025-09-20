//
//  DeckContent.swift
//  Flashcards
//
//  Created by Jason Hirst on 8/1/24.
//

import Foundation

struct DeckContent<CardContent>: Identifiable {
    var name: String
    var color: RGBA
    
    var id = UUID()
    
    private(set) var contentSet: [(front: CardContent, back: CardContent)]
    
    init(name: String, color: RGBA, contentSet: [(front: CardContent, back: CardContent)]) {
        self.name = name
        self.color = color
        self.contentSet = contentSet
    }
}
