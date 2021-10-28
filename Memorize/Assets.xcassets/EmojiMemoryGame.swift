//
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by Arkasha Zuev on 26.10.2021.
//

import SwiftUI

class EmojiMemoryGame: ObservableObject {
    static let emojis: Array<String> = ["🍏", "🍎", "🍋", "🍊", "🍉", "🍇", "🍓", "🫐", "🍒", "🍑", "🥭", "🍍", "🥥", "🥝", "🍅", "🍆", "🥑", "🥦", "🥬", "🥒", "🌶", "🫑", "🌽"]
    
    static func createMemoryGame() -> MemoryGame<String> {
        MemoryGame<String>(numberOfPairsOfCards: 4) { index in
            emojis[index]
        }
    }
    
    @Published private var model: MemoryGame<String> = createMemoryGame()
    
    var cards: Array<MemoryGame<String>.Card> {
        return model.cards
    }
    
    // MARK: - Intent(s)
    
    func choose(_ card: MemoryGame<String>.Card) {
        model.choose(card)
    }
}
