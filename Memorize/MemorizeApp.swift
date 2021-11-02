//
//  MemorizeApp.swift
//  Memorize
//
//  Created by Arkasha Zuev on 26.10.2021.
//

import SwiftUI

@main
struct MemorizeApp: App {
    private let game = EmojiMemoryGame()
    
    var body: some Scene {
        WindowGroup {
            EmojiMemoryGameView(game: game)
//                .preferredColorScheme(.dark)
        }
    }
}
