//
//  OnboardingView.swift
//  Locus
//
//  Created by Hafiz Rahmadhani on 17/10/25.
//

import SwiftUI
struct GlassButton: View {
    var text: String
    var action: () -> Void
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        Button(action: action) {
            Text(text)
                .font(.headline)
                .foregroundColor(colorScheme == .dark ? .black : .white)
                .frame(width: 318, height: 48)
                .background(
                    ZStack {
                        RoundedRectangle(cornerRadius: 16)
                            .fill(colorScheme == .dark ? Color.white.opacity(0.6) : Color.black.opacity(0.6))
                            .blur(radius: 7)
                    }
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.white.opacity(0.3), lineWidth: 1)
                )
                .cornerRadius(16)
                .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
        }
    }
}
struct OnboardingView: View {
    
    @State var moveToMainPageView = false
    @Environment(\.colorScheme) private var colorScheme
    @Binding var hasSeenOnboarding: Bool
    @State private var pageIndex = 0
    
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
                Group {
                    switch pageIndex {
                    case 0:
                        VStack(spacing: 20) {
                            Text("“In the journal I am at ease.“")
                                .font(.headline)
                                .foregroundStyle(.primary)
                            Text("~ Anais Nin")
                                .foregroundStyle(.primary)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 40)
                        }
                        
                    case 1:
                        VStack(spacing: 20) {
                            Image(systemName: "graduationcap")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 177, height: 112)
                                .foregroundStyle(.primary)
                            Text("Hello, Global Student!")
                                .font(.title)
                                .fontWeight(.semibold)
                                .foregroundStyle(.primary)
                            Text("Welcome to your safe space for reflection, growth, and connection.")
                                .foregroundStyle(.primary)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 40)
                        }
                        
                    case 2:
                        VStack(spacing: 20) {
                            Image(systemName: "pencil.and.outline")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 120, height: 120)
                                .foregroundStyle(.primary)
                            Text("Curated Prompts Just For You")
                                .font(.title)
                                .fontWeight(.semibold)
                                .foregroundStyle(.primary)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 40)
                            Text("We offer specific prompts designed for the unique challenges of international students.")
                                .foregroundStyle(.primary)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 40)
                        }
                        
                    default:
                        EmptyView()
                    }
                }
                
                Spacer()
                
                switch pageIndex {
                case 0:
                    GlassButton(text: "Get Started") {
                        withAnimation { pageIndex = 1 }
                    }
                    .padding(.bottom, 10)
                    
                case 1:
                    GlassButton(text: "Continue") {
                        withAnimation { pageIndex = 2 }
                    }
                    .padding(.bottom, 10)
                    
                case 2:
                    GlassButton(text: "Start Journey") {
                        hasSeenOnboarding = true
                        moveToMainPageView = true
                    }
                    .padding(.bottom, 10)
                    
                default:
                    MainPageView()
                }
            }
        }
        .navigationDestination(isPresented : $moveToMainPageView, destination: {
            MainPageView()
        })
    }
    
    
}

#Preview {
    OnboardingView(hasSeenOnboarding: .constant(false))
        .preferredColorScheme(.dark)
}
