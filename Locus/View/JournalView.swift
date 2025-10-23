//
//  JournalView.swift
//  Locus
//
//  Created by Gaetano Pascarella on 17/10/25.
//

import SwiftUI

struct JournalView: View {
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) private var colorScheme
    
    @State private var journalText: String = ""
    @State private var selectedMood: Int? = nil
    @State private var date: Date = Date()
    @State private var selectedEmoji: String = "😊"
    var entryToEdit: JournalEntry?
    var feelingEmoji: String
    
    var onSaveComplete: () -> Void
    @FocusState private var isTextEditorFocused: Bool
    
    private let moodEmojis = ["😡", "😢", "😊", "😐"]
    private let moodImages = ["Image 1", "Image 2", "Image 3", "Image 4", ]
    
    var body: some View {
        ZStack {
            VStack(spacing: 20) {
                HStack {
                    Button(action: { dismiss() }) {
                        Image(systemName: "chevron.left")
                            .font(.title)
                            .padding(3)
                            .foregroundStyle(.white)
                    }
                    .glassEffect(.clear
                        .tint(Color.primary.opacity(9))
                        .interactive()
                    )
                    .clipShape(Circle())
                    .buttonStyle(.glass)
                    
                    Spacer()
                    
                    Text("Your Journal")
                        .font(.system(size: 28, weight: .semibold))
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.top, 6)
                    
                    Spacer()
                    
                    Button(action: { saveEntry() }) {
                        Image(systemName: "checkmark")
                            .font(.title)
                            .padding(3)
                            .foregroundStyle(.white)
                    }
                    .glassEffect(.clear
                        .tint(Color.primary.opacity(9))
                        .interactive()
                    )
                    .clipShape(Circle())
                    .buttonStyle(.glass)
                }
                .padding(.horizontal)
                .padding(.top, 5)
                
                Text("How was your day?")
                    .font(.headline)
                    .foregroundColor(.primary)
                    .padding(.top, 10)
                
                HStack(spacing: 16) {
                    ForEach(0..<moodImages.count, id: \.self) { index in
                        moodButton(index: index, imageName: moodImages[index])
                    }
                }
                .padding(.horizontal)
                
                ZStack(alignment: .topLeading) {
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .fill(colorScheme == .dark ? Color.white.opacity(0.65)
                              : Color.black.opacity(0.3))
                        .overlay(
                            RoundedRectangle(cornerRadius: 20, style: .continuous)
                                .stroke(Color.white.opacity(0.5), lineWidth: 1)
                        )
                        .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
                    
                    VStack(alignment: .leading, spacing: 0) {
                        TextEditor(text: $journalText)
                            .textEditorStyle(.plain)
                            .scrollContentBackground(.hidden)
                            .foregroundColor(.primary)
                            .font(.body)
                            .background(Color.clear)
                            .frame(maxWidth: .infinity)
                            .focused($isTextEditorFocused)
                    }
                    .padding(.horizontal, 18)
                    .padding(.vertical, 16)
                    
                    if journalText.isEmpty {
                        Text("Write your thoughts here...")
                            .foregroundColor(.white.opacity(0.7))
                            .font(.body)
                            .padding(.horizontal, 24)
                            .padding(.vertical, 24)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.horizontal)
                .padding(.top, 2)
                
                Spacer(minLength: 20)
            }
            .padding(.top)
            .padding(.bottom, 24)
            
            .onAppear {
                loadExistingEntry()
            }
            
        }
        .appBackground()
        .navigationBarBackButtonHidden(true)
        .scrollDismissesKeyboard(.interactively)
        .onTapGesture {
            isTextEditorFocused = false
        }
    }
    
    @ViewBuilder
    private func moodButton(index: Int, imageName: String) -> some View {
        let isSelected = selectedMood == index
        Button {
            selectedMood = index
            selectedEmoji = moodEmojis[index]
        } label: {
            Image(imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 56, height: 56)
                .padding(8)
                .background(
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .fill(colorScheme == .dark ? Color.white.opacity(0.6)
                              : Color.black.opacity(0.6))
                        .blur(radius: 4)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .stroke(isSelected ? Color.black.opacity(0.3) : Color.white.opacity(0.3), lineWidth: isSelected ? 2 : 1)
                )
                .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
                .scaleEffect(isSelected ? 1.06 : 1.0)
                .animation(.spring(response: 0.25, dampingFraction: 0.8), value: isSelected)
        }
        .buttonStyle(.plain)
    }
    
    private func loadExistingEntry() {
        
        if let entry = entryToEdit {
            journalText = entry.text
            selectedEmoji = entry.feelingEmoji
            
            if let moodIndex = moodEmojis.firstIndex(of: entry.feelingEmoji) {
                selectedMood = moodIndex
            }
        } else {
            selectedEmoji = feelingEmoji
            if let moodIndex = moodEmojis.firstIndex(of: feelingEmoji) {
                selectedMood = moodIndex
            }
        }
    }
    
    private func saveEntry() {
        var entries = FileManagerHelper.load(from: date)
        
        if let entryToEdit = entryToEdit {
            if let index = entries.firstIndex(where: { $0.id == entryToEdit.id }) {
                if journalText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    entries.remove(at: index)
                } else {
                    entries[index].text = journalText
                    entries[index].feelingEmoji = selectedEmoji
                    entries[index].date = Date()
                }
            }
        } else {
            guard !journalText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
                dismiss()
                return
            }
            let newEntryDate = createDate(from: date)
            let newEntry = JournalEntry(date: newEntryDate, feelingEmoji: selectedEmoji, text: journalText)
            entries.append(newEntry)
        }
        FileManagerHelper.save(entries: entries, for: date)
        onSaveComplete()
        dismiss()
    }
    
    private func createDate(from selectedDate: Date) -> Date {
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.year, .month, .day], from: selectedDate)
        let timeComponents = calendar.dateComponents([.hour, .minute, .second], from: Date())
        
        var finalComponents = DateComponents()
        finalComponents.year = dateComponents.year
        finalComponents.month = dateComponents.month
        finalComponents.day = dateComponents.day
        finalComponents.hour = timeComponents.hour
        finalComponents.minute = timeComponents.minute
        finalComponents.second = timeComponents.second
        
        return calendar.date(from: finalComponents) ?? Date()
    }
}

#Preview {
    JournalView(
        entryToEdit: nil,
        feelingEmoji: "😊",
        onSaveComplete: {
            print("Preview save complete!")
        }
    )
}
