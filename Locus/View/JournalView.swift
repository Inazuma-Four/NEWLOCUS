//
//  JournalUIView.swift
//  JournalApp
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
    
    private let moodEmojis = ["😡", "😢", "😊", "😐"]
    private let moodImages = ["Image 1", "Image 2", "Image 3", "Image 4", ]
    
    var body: some View {
        ZStack {
            ScrollView {
                VStack(spacing: 20) {
                    HStack {
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
                            .padding(.top, 6)
                        
                        Spacer()
                        
                        Button(action: { saveEntry() }) {
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
                    }
                    .padding(.horizontal)
                    .padding(.top, 5)
                    
                    Text("How was your day?")
                        .font(.headline)
                        .foregroundColor(.primary)
                        .padding(.top, 10)
                    
                    // Mood selector
                    HStack(spacing: 16) {
                        ForEach(0..<moodImages.count, id: \.self) { index in
                            moodButton(index: index, imageName: moodImages[index])
                        }
                    }
                    .padding(.horizontal)
                    
                    // Journal text area
                    ZStack(alignment: .topLeading) {
                        RoundedRectangle(cornerRadius: 20, style: .continuous)
                            .fill(Color.gray.opacity(0.70))
                        
                        VStack(alignment: .leading, spacing: 0) {
                            TextEditor(text: $journalText)
                                .textEditorStyle(.plain)
                                .scrollContentBackground(.hidden)
                                .foregroundColor(.primary)
                                .font(.body)
                                .background(Color.clear)
                                .frame(maxWidth: .infinity, minHeight: 300)
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
                    .frame(maxWidth: .infinity, minHeight: 500)
                    .padding(.horizontal)
                    .padding(.top, 2)
                    
                    Spacer(minLength: 20)
                }
                .padding(.top)
                .padding(.bottom, 24)
            }
            .scrollDismissesKeyboard(.interactively)
            .onAppear {
                loadExistingEntry()
            }
            
        }
        .appBackground()
        .navigationBarBackButtonHidden(true)
    }
    
    // MARK: - Mood Button
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
    
    // MARK: - File Handling
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
    
    // CHANGE: The save logic is now more advanced.
        private func saveEntry() {
            // 1. Load all existing entries for the given date.
            var entries = FileManagerHelper.load(from: date)
            
            if let entryToEdit = entryToEdit {
                // EDITING an existing entry
                // Find the index of the entry we are editing.
                if let index = entries.firstIndex(where: { $0.id == entryToEdit.id }) {
                    if journalText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                        // If text is cleared, remove the entry.
                        entries.remove(at: index)
                    } else {
                        // Otherwise, update its properties.
                        entries[index].text = journalText
                        entries[index].feelingEmoji = selectedEmoji
                        // Update the date to reflect the edit time
                        entries[index].date = Date()
                    }
                }
            } else {
                // ADDING a new entry
                // Don't save if the text is empty.
                guard !journalText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
                    dismiss()
                    return
                }
                // Use the current date and time for the new entry, but the day from the selectedDate
                let newEntryDate = createDate(from: date)
                let newEntry = JournalEntry(date: newEntryDate, feelingEmoji: selectedEmoji, text: journalText)
                entries.append(newEntry)
            }
            
            // 2. Save the entire (potentially modified) array back to the file.
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
