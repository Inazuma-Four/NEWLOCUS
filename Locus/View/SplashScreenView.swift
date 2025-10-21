//
//  SplashScreenView.swift
//  Locus
//
//  Created by Hafiz Rahmadhani on 17/10/25.
//


import SwiftUI

struct SplashScreenView: View {
    
    @State private var opacity = 1.0
    @Environment(\.colorScheme) var colorScheme
    @Binding var isFirst : Bool

    var body: some View {
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

            VStack {
                Spacer()
                Image(colorScheme == .dark ? "logo_dark" : "logo_light")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 250, height: 250)
                                    .opacity(opacity)
                                    .onAppear {
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                            withAnimation {
                                                self.isFirst = false
                                            }
                                        }
                                    }
                Text("Locus")
                    .font(.system(size: 30, weight: .semibold))
                    .foregroundColor(colorScheme == .dark ? .white : .black)
                    .opacity(opacity)
                    .onAppear {
                        withAnimation(.easeOut(duration: 3.5)) {
                            opacity = 0.0
                        }
                    }

                Spacer()
            }
        }
    }
}

#Preview {
    SplashScreenView(isFirst: .constant(true))
}
