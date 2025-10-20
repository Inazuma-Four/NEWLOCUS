//
//  BackgroundImageModifier.swift
//  Locus
//
//  Created by Hafiz Rahmadhani on 17/10/25.
//

import SwiftUI

struct BackgroundImageModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(
                Image("background")
//                    .resizable()
                    .scaledToFit()
                    .ignoresSafeArea()
            )
    }
}

extension View {
    func appBackground() -> some View {
        self.modifier(BackgroundImageModifier())
    }
}
