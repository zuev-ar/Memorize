//
//  MemorizeApp.swift
//  Memorize
//
//  Created by Arkasha Zuev on 26.10.2021.
//

import SwiftUI

@main
struct MemorizeApp: App {
    let game = EmojiMemoryGame()
    
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: game)
//                .preferredColorScheme(.dark)
        }
    }
}
