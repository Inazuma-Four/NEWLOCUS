//
//  JournalUIView.swift
//  JournalApp
//
//  Created by Gaetano Pascarella on 17/10/25.
//

import SwiftUI

struct JournalView: View {
    
    @Environment(\.dismiss) private var dismiss
    @State private var journalText: String = ""
    @State private var selectedMood: Int? = nil
    
    
    
    
    var body: some View {
        ZStack{
            Image("background")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            GeometryReader { geometry in
                VStack(spacing: 20){
                    
                    HStack{
                        Button(action: { dismiss() }) {
                            Image(systemName: "chevron.left")
                                .font(.title)
                                .padding(3)
                                .foregroundStyle(.white)
                        }
                        .glassEffect(.clear
                            .tint(Color.gray.opacity(0.8))
                            .interactive()
                        )
                        .clipShape(Circle())
                        .buttonStyle(.glass)
                        
                        Spacer()
                        
                        Text("Your Journal")
                            .font(.system(size: 28, weight: .semibold))
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding(.top,6)
                        
                        Spacer()
                        
                        Button(action: {/*action*/() }) {
                            Image(systemName: "checkmark")
                                .font(.title)
                                .padding(3)
                                .foregroundStyle(.white)
                        }
                        .glassEffect(.clear
                            .tint(Color.gray.opacity(0.8))
                            .interactive()
                        )
                        .clipShape(Circle())
                        .buttonStyle(.glass)
                        
                        
                    }//END HStack
                    .padding(.horizontal)
                    .padding(.top, 40)
                    
                    Text("How was your day?")
                        .font(.headline)
                        .foregroundColor(.black)
                        .padding(.top, 10)
                    
                    // Mood selector
                    HStack(spacing: 16) {
                        moodButton(index: 0, imageName: "Image 3")
                        moodButton(index: 1, imageName: "Image 4")
                        moodButton(index: 2, imageName: "Image 1")
                        moodButton(index: 3, imageName: "Image 2")
                    }
                    .padding(.horizontal)
                    
                    // Journal text area
                    ZStack(alignment: .topLeading) {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.gray.opacity(0.70))
                            
                        
                        if journalText.isEmpty {
                            Text("Write your thoughts here...")
                                .foregroundColor(.white.opacity(0.7))
                                .padding(.horizontal, 20)
                                .padding(.vertical, 20)
                                .font(.body)
                        }
                        
                        TextEditor(text: $journalText)
                            .padding(12)
                            .scrollContentBackground(.hidden)
                            .background(Color.clear)
                    }
                    .frame(height: 550)
                    .padding(.horizontal)
                    .padding(.top, geometry.size.height * 0)
                    Spacer(minLength: 20)
                        
                }
                .padding(.top)
            }
        }
        .navigationBarBackButtonHidden(true)
        
    }//END ZStack
    
    @ViewBuilder
    private func moodButton(index: Int, imageName: String) -> some View {
        let isSelected = selectedMood == index
        Button {
            selectedMood = index
        } label: {
            Image(imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 56, height: 56)
                .padding(8)
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .stroke(isSelected ? Color.blue.opacity(0.9) : Color.white.opacity(0.25), lineWidth: isSelected ? 2 : 1)
                )
                .shadow(color: isSelected ? Color.blue.opacity(0.25) : Color.black.opacity(0.1), radius: isSelected ? 8 : 4, x: 0, y: 2)
                .scaleEffect(isSelected ? 1.06 : 1.0)
                .animation(.spring(response: 0.25, dampingFraction: 0.8), value: isSelected)
        }
        .buttonStyle(.plain)
    }
}


#Preview {
    JournalView()
}

