import SwiftUI

// GANTI SELURUH FILE ANDA DENGAN INI
struct JournalPromptView: View {
    
    // 1. PROPERTI BARU (Mirip JournalView)
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) private var colorScheme
    
    var entryToEdit: JournalEntry? = nil // Untuk mode Edit
    var newPromptText: String? = nil    // Untuk mode Entri Baru
    var onSaveComplete: () -> Void
    
    // State untuk menyimpan data
    @State private var journalText: String = "" // Jawaban pengguna
    @State private var promptText: String = ""  // Teks prompt
    @State private var selectedMood: Int? = nil
    @State private var date: Date = Date()
    @State private var selectedEmoji: String = "😊"
    
    // Mapping (harus sama dengan JournalView)
    private let moodEmojis = ["😡", "😢", "😊", "😐"]
    private let moodImages = ["Image 1", "Image 2", "Image 3", "Image 4"]

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                
                // Header
                HStack {
                    Button(action: { dismiss() }) {
                        Image(systemName: "chevron.left")
                            .font(.title).padding(3).foregroundStyle(.white)
                    }
                    .glassEffect(.clear
                        .tint(Color.primary.opacity(9))
                        .interactive()
                    )
                    .clipShape(Circle()).buttonStyle(.glass)
                    
                    Spacer()
                    Text("Prompt Journal")
                        .font(.system(size: 28, weight: .semibold))
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.top, 6)
                    Spacer()
                    Button(action: { saveEntry() }) {
                        Image(systemName: "checkmark")
                            .font(.title).padding(3).foregroundStyle(.white)
                    }
                    .glassEffect(.clear
                        .tint(Color.primary.opacity(9))
                        .interactive()
                    )
                    .clipShape(Circle()).buttonStyle(.glass)
                }
                .padding(.horizontal).padding(.top, 5)

                Text("How was your day?")
                    .font(.headline).foregroundColor(.primary).padding(.top, 10)

                // Mood selector
                HStack(spacing: 16) {
                    ForEach(0..<moodImages.count, id: \.self) { index in
                        moodButton(index: index, imageName: moodImages[index])
                    }
                }
                .padding(.horizontal)

                Spacer(minLength: 10)

                // Kotak Prompt
                VStack(alignment: .leading, spacing: 8) {
                    Text("Prompt of day")
                        .font(.headline).fontWeight(.bold).foregroundColor(.primary) // Disesuaikan
                    
                    // Gunakan @State promptText
                    Text(promptText)
                        .font(.subheadline).foregroundColor(.secondary) // Disesuaikan
                        .multilineTextAlignment(.leading)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(.thinMaterial) // Disesuaikan
                .overlay(
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                )
                .cornerRadius(14)
                .padding(.horizontal)

                // Text Editor
                ZStack(alignment: .topLeading) {
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .fill(colorScheme == .dark ? Color.white.opacity(0.65)
                              : Color.black.opacity(0.3))
                        .overlay(
                            RoundedRectangle(cornerRadius: 20, style: .continuous)
                                .stroke(Color.white.opacity(0.5), lineWidth: 1)
                        )
                        .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
                    TextEditor(text: $journalText) // Gunakan @State journalText
                        .padding(12).scrollContentBackground(.hidden)
                        .foregroundColor(.primary).font(.body)
                        .frame(minHeight: 350)

                    if journalText.isEmpty {
                        Text("Write your thoughts...")
                            .foregroundColor(.white.opacity(0.7))
                            .padding(.horizontal, 20).padding(.vertical, 20)
                            .font(.body).allowsHitTesting(false)
                    }
                }
                .padding(.horizontal).padding(.top, 20)
                Spacer()
            }
            .padding(.bottom)
        }
        .appBackground()
        .navigationBarBackButtonHidden(true)
        .onAppear {
            // 2. FUNGSI BARU UNTUK MEMUAT DATA
            loadExistingEntry()
        }
        .onTapGesture {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
    }

    // Mood Button (Sudah benar dari sebelumnya)
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

    // MARK: - File Handling (DI-UPGRADE)
    
    // 3. FUNGSI BARU: loadExistingEntry
    private func loadExistingEntry() {
        if let entry = entryToEdit {
            // --- MODE EDIT ---
            // Pecah teks "Prompt: [teks]\n\n[jawaban]"
            let components = entry.text.components(separatedBy: "\n\n")
            if components.count >= 2 {
                // Ambil prompt (menghapus "Prompt: ")
                self.promptText = components[0].replacingOccurrences(of: "Prompt: ", with: "")
                // Ambil sisanya sebagai jawaban
                self.journalText = components.dropFirst().joined(separator: "\n\n")
            } else {
                // Fallback jika formatnya aneh
                self.promptText = "Error loading prompt"
                self.journalText = entry.text
            }
            
            // Muat data lain (copy dari JournalView.loadExistingEntry)
            self.selectedEmoji = entry.feelingEmoji
            if let moodIndex = moodEmojis.firstIndex(of: entry.feelingEmoji) {
                self.selectedMood = moodIndex
            }
            
        } else if let newPrompt = newPromptText {
            // --- MODE ENTRI BARU ---
            self.promptText = newPrompt
            // (journalText sudah otomatis "" dari @State)
        }
    }
    
    // 4. FUNGSI UPGRADE: saveEntry (Bisa Edit & Tambah)
    private func saveEntry() {
        var entries = FileManagerHelper.load(from: date)
        
        // Gabungkan kembali teksnya
        let fullJournalText = "Prompt: \(promptText)\n\n\(journalText)"

        if let entryToEdit = entryToEdit {
            // --- MODE EDIT ---
            if let index = entries.firstIndex(where: { $0.id == entryToEdit.id }) {
                if journalText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    entries.remove(at: index)
                } else {
                    entries[index].text = fullJournalText // Simpan teks yang sudah digabung
                    entries[index].feelingEmoji = selectedEmoji
                    entries[index].date = Date()
                }
            }
        } else {
            // --- MODE ENTRI BARU ---
            guard !journalText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
                dismiss()
                return
            }
            let newEntryDate = createDate(from: date)
            let newEntry = JournalEntry(date: newEntryDate, feelingEmoji: selectedEmoji, text: fullJournalText)
            entries.append(newEntry)
        }
         
        FileManagerHelper.save(entries: entries, for: date)
        onSaveComplete()
        dismiss()
    }
    
    private func createDate(from selectedDate: Date) -> Date {
        // (Helper function ini tidak berubah)
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

// 5. PERBARUI PREVIEW
#Preview {
    JournalPromptView(
        // Gunakan 'newPromptText' untuk preview
        newPromptText: "This is a preview prompt. What are you grateful for today?",
        onSaveComplete: {
            print("Preview save complete!")
        }
    )
}
