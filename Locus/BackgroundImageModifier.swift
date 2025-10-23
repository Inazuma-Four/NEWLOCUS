//
//  BackgroundImageModifier.swift
//  Locus
//
//  Created by Hafiz Rahmadhani on 17/10/25.
//

import SwiftUI



struct BackgroundImageModifier: ViewModifier {
    
    @Environment(\.colorScheme) private var colorScheme
    
    func body(content: Content) -> some View {
        ZStack {
            Group {
                if colorScheme == .dark {
                    LinearGradient(
                        colors: [
                            Color.black,
                            Color(red: 0.3, green: 0.3, blue: 0.35)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                } else {
                    LinearGradient(
                        colors: [
                            Color.white,
                            Color(red: 0.7, green: 0.7, blue: 0.75)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                }
            }
            .ignoresSafeArea()
            content
        }
        
    }
}

extension View {
    func appBackground() -> some View {
        self.modifier(BackgroundImageModifier())
    }
}
