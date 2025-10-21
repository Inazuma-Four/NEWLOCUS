//
//  PromptView.swift
//  Locus
//
//  Created by Hafiz Rahmadhani on 17/10/25.
//

import SwiftUI

struct PromptView: View {
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) private var colorScheme
    
    @State var moveToJournalPromptView = false
    @State var moveToJournalView = false
    @State var todayPrompt: String = ""
    var prompt = AppConstant()
    
    var body: some View {
        VStack(alignment: .leading){
            Button(action: {dismiss() }) {
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
            //.padding(.horizontal, 27)
            .buttonStyle(.glass)
            .padding(.top)
            VStack{
                VStack(alignment: .leading, spacing: 7) {
                    Text("Today’s Prompt")
                        .bold()
                        .font(.title2)
//                        .foregroundStyle(.white)
//                        .padding(.bottom)
                        .font(.subheadline)
                        .padding(.bottom)
                        //.multilineTextAlignment(.center)
                        //.foregroundColor(.secondary)
                    
                    Text(todayPrompt)
                        //.foregroundStyle(.white)
                        .lineLimit(3)
                        .padding(.bottom)
                        //.font(.body)
                    
                    
                }
                .padding()
                .frame(width: 350)
                .glassEffect(
                    .clear
                        .tint(Color.gray.opacity(0.6))
                        .interactive(),
                    in: RoundedRectangle(cornerRadius: 10)
                )
                
                Button {
                    moveToJournalPromptView = true
                } label: {
                    Text("Reflect on this prompt")
                        .font(.headline)
                        .foregroundColor(colorScheme == .dark ? .black : .white) // <- cambia qui
                        .frame(width: 350, height: 48)
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
//                        .frame(maxWidth: .infinity)
//                        .padding()
                }
//                .glassEffect(
//                    .clear
//                        .tint(Color.gray.opacity(0.6))
//                        .interactive()
//                )
//                .foregroundStyle(Color.white)
//                .padding(.horizontal, 30)
                .padding(.top, 10)
                
                Button {
                    moveToJournalView = true
                } label: {
                    Text("Write on your own")
                        .font(.headline)
                        .foregroundColor(colorScheme == .dark ? .black : .white) // <- cambia qui
                        .frame(width: 350, height: 48)
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
//                        .frame(maxWidth: .infinity)
//                        .padding()
                }
//                .glassEffect(
//                    .clear
//                        .tint(Color.gray.opacity(0.6))
//                        .interactive()
//                )
//                .foregroundStyle(Color.white)
//                .padding(.horizontal, 30)
                .padding(.top,5)
                
                Spacer()
            }
            .padding(.top, 20)
        }
        
        //.navigationDestination(isPresented: $moveToJournalPromptView) {
           // JournalPromptView()
        //}
        .navigationDestination(isPresented: $moveToJournalPromptView) {
            JournalPromptView(promptText: todayPrompt)
        }

        
        .navigationDestination(isPresented: $moveToJournalView) {
            JournalView(
                entryToEdit: nil,
                feelingEmoji: "😊",
                onSaveComplete : {
                    dismiss()
                }
            )
        }
        .onAppear {
            let currentDate = getCurrentDateString()
            let savedDate = UserDefaults.standard.string(forKey: "lastPromptDate")
            let savedPrompt = UserDefaults.standard.string(forKey: "todayPrompt")
            
            if savedDate == currentDate, let prompt = savedPrompt {
                todayPrompt = prompt
            } else {
                let lastIndex = UserDefaults.standard.integer(forKey: "lastPromptIndex")
                let newIndex = (lastIndex + 1) % prompt.promptJournal.count
                let newPrompt = prompt.promptJournal[newIndex]
                
                UserDefaults.standard.set(newPrompt, forKey: "todayPrompt")
                UserDefaults.standard.set(currentDate, forKey: "lastPromptDate")
                UserDefaults.standard.set(newIndex, forKey: "lastPromptIndex")
                
                todayPrompt = newPrompt
            }
        }
        .navigationBarBackButtonHidden(true)
        .appBackground()
        
        
    }
    
    
    func getCurrentDateString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: Date())
    }
    
}



#Preview {
    PromptView()
}
