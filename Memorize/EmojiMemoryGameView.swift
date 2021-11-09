//
//  ContentView.swift
//  Memorize
//
//  Created by Arkasha Zuev on 26.10.2021.
//

import SwiftUI

struct EmojiMemoryGameView: View {
    @ObservedObject var game: EmojiMemoryGameViewModel
    @Namespace private var dealingNamespace
    @State private var dealt = Set<Int>()
    
    private func deal(_ card: EmojiMemoryGameViewModel.Card) {
        dealt.insert(card.id)
    }
    
    private func isUndealt(_ card: EmojiMemoryGameViewModel.Card) -> Bool {
        !dealt.contains(card.id)
    }
    
    private func dealAnimation(for card: EmojiMemoryGameViewModel.Card) -> Animation {
        var delay = 0.0
        if let index = game.cards.firstIndex(where: { $0.id == card.id }) {
            delay = Double(index) * (CardConstants.totalDealDuration / Double(game.cards.count))
        }
        return Animation.easeInOut(duration: CardConstants.dealDuration).delay(delay)
    }
    
    private func zIndex(of card: EmojiMemoryGameViewModel.Card) -> Double {
        -Double(game.cards.firstIndex(where: { $0.id == card.id }) ?? 0)
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            VStack {
                gameBody
                HStack {
                    restart
                    Spacer()
                    shuffle
                }
            }
            deckBody
        }
        .padding(.horizontal)
    }
    
    var gameBody: some View {
        AspectVGridView(items: game.cards, aspectRatio: CardConstants.aspectRatio) { card in
            if isUndealt(card) || (card.isMatched && !card.isFaceUp) {
                Color.clear
            } else {
                CardView(card: card)
                    .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                    .padding(4)
                    .transition(AnyTransition.asymmetric(insertion: .identity, removal: .scale).animation(.easeInOut(duration: 1)))
                    .zIndex(zIndex(of: card))
                    .onTapGesture {
                        withAnimation(.easeInOut(duration: CardConstants.dealDuration)) {
                            game.choose(card)
                        }
                    }
            }
        }
        .foregroundColor(CardConstants.color)
    }
    
    var deckBody: some View {
        ZStack {
            ForEach(game.cards.filter(isUndealt)) { card in
                CardView(card: card)
                    .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                    .transition(AnyTransition.asymmetric(insertion: .opacity, removal: .identity).animation(.easeInOut(duration: 1)))
            }
        }
        .frame(width: CardConstants.undealWidth, height: CardConstants.undealHeight)
        .foregroundColor(CardConstants.color)
        .onTapGesture {
            for card in game.cards {
                withAnimation(dealAnimation(for: card)) {
                    deal(card)
                }
            }
        }
    }
    
    var shuffle: some View {
        Button("Shuffle") {
            withAnimation {
                game.shuffle()
            }
        }
    }
    
    var restart: some View {
        Button("Restart") {
            withAnimation {
                dealt = []
                game.restart()
            }
        }
    }
    
    private struct CardConstants {
        static let color = Color.red
        static let aspectRatio: CGFloat = 0.75
        static let dealDuration: Double = 0.5
        static let totalDealDuration: Double = 2
        static let undealHeight: CGFloat = 90
        static let undealWidth = undealHeight * aspectRatio
    }
}

struct CardView: View {
    @State private var animatedBonusRemaining: Double = 0
    
    let card: EmojiMemoryGameViewModel.Card
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Group {
                    if card.isConsumingBonusTime {
                        Pie(startAngle: Angle(degrees: 0 - 90), endAngle: Angle(degrees: (1 - animatedBonusRemaining) * 360 - 90))
                            .onAppear {
                                animatedBonusRemaining = card.bonusRemaining
                                withAnimation(.linear(duration: card.bonusTimeRemaining)) {
                                    animatedBonusRemaining = 0
                                }
                            }
                    } else {
                        Pie(startAngle: Angle(degrees: 0 - 90), endAngle: Angle(degrees: (1 - card.bonusRemaining) * 360 - 90))
                    }
                }
                .padding(5)
                .opacity(0.5)
                
                Text(card.content)
                    .rotationEffect(Angle.degrees(card.isMatched ? 360 : 0))
                    .animation(Animation.linear(duration: 1))
                    .font(Font.system(size: DrawingConstants.fontSize))
                    .scaleEffect(scale(in: geometry.size))
            }
            .cardify(isFaceUp: card.isFaceUp)
        }
    }
    
    private func scale(in size: CGSize) -> CGFloat {
        return min(size.width, size.height) / (DrawingConstants.fontSize / DrawingConstants.fontScale)
    }
    
    private struct DrawingConstants {
        static let fontScale: CGFloat = 0.7
        static let fontSize: CGFloat = 32
    }
}
