//
//  ContentView.swift
//  ActivityTesting1
//
//  Created by Mohsin Amir Siddiqui on 21/10/25.
//

import SwiftUI

// MARK: - 1. Data Model
// This struct represents a single journal entry.
// Codable allows us to easily convert it to/from JSON for file storage.
//struct JournalEntry: Codable, Identifiable {
//    var id: String {
//        // FIX 1: Replaced newer .formatted() method with DateFormatter for broader iOS compatibility.
//        let formatter = DateFormatter()
//        formatter.dateFormat = "yyyy-MM-dd"
//        return formatter.string(from: date)
//    }
//    var date: Date
//    var feelingEmoji: String
//    var text: String
//}

// MARK: - 2. File Manager Helper
// This helper class makes saving and loading our JournalEntry data easy and clean.
//class FileManagerHelper {
//
//    // Gets the URL for the app's documents directory.
//    private static func getDocumentsDirectory() -> URL {
//        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
//    }
//
//    // Creates a unique filename for each entry based on its date.
//    private static func fileURL(for date: Date) -> URL {
//        let formatter = DateFormatter()
//        formatter.dateFormat = "yyyy-MM-dd"
//        let dateString = formatter.string(from: date)
//        return getDocumentsDirectory().appendingPathComponent("\(dateString).json")
//    }
//
//    // Saves a JournalEntry to a file.
//    static func save(entry: JournalEntry) {
//        let url = fileURL(for: entry.date)
//        do {
//            let data = try JSONEncoder().encode(entry)
//            try data.write(to: url, options: [.atomic, .completeFileProtection])
//            print("✅ Entry saved to \(url.path)")
//        } catch {
//            print("❌ Failed to save entry: \(error.localizedDescription)")
//        }
//    }
//
//    // Loads a JournalEntry from a file.
//    static func load(from date: Date) -> JournalEntry? {
//        let url = fileURL(for: date)
//        if FileManager.default.fileExists(atPath: url.path) {
//            do {
//                let data = try Data(contentsOf: url)
//                let entry = try JSONDecoder().decode(JournalEntry.self, from: data)
//                print("✅ Entry loaded for \(date.formatted(date: .long, time: .omitted))")
//                return entry
//            } catch {
//                print("❌ Failed to load or decode entry: \(error.localizedDescription)")
//            }
//        }
//        return nil
//    }
//
//    // Deletes a journal entry for a specific date
//    static func delete(for date: Date) {
//        let url = fileURL(for: date)
//        if FileManager.default.fileExists(atPath: url.path) {
//            do {
//                try FileManager.default.removeItem(at: url)
//                print("🗑️ Entry deleted for \(date.formatted(date: .long, time: .omitted))")
//            } catch {
//                print("❌ Failed to delete entry: \(error.localizedDescription)")
//            }
//        }
//    }
//}


// MARK: - 3. Main Content View (Activity Page)
struct MainPageView: View {
    @State private var selectedDate = Date()
    @State private var currentEntry: JournalEntry?
    @State private var promptView = false
    @State private var showingFullCalendar = false
    @State private var entriesForSelectedDate: [JournalEntry] = []
    @State private var entryToEdit: JournalEntry?
    @State private var showingJournalEntryView = false
    @State private var navPath = NavigationPath()
    
    var body: some View {
        NavigationStack(path: $navPath) {
            ZStack {
                
                VStack(spacing: 0) {
                    // Header: Title and Add Button
                    headerView
                    
                    // Horizontal Calendar
                    HorizontalCalendarView(selectedDate: $selectedDate, showingFullCalendar: $showingFullCalendar)
                        .padding(.bottom, 20)
                    
                    // Journal Display Area
                    journalDisplayView
                    
                    Spacer()
                }
            }
            .onChange(of: selectedDate) { _, newDate in
                loadEntries(for: newDate)
            }
            .onAppear {
                loadEntries(for: selectedDate)
            }
            .sheet(isPresented: $showingFullCalendar) {
                FullCalendarView(selectedDate: $selectedDate)
            }
//            .sheet(isPresented: $showingJournalEntryView, onDismiss: {
//                loadEntries(for: selectedDate)
//            })
//            {
//                JournalView(
//                    entryToEdit: entryToEdit,
//                    feelingEmoji: entryToEdit?.feelingEmoji ?? "😊",
//                    onSaveComplete: {
//
//                })
//            }
//            .navigationDestination(for: String.self) { pagename in
//                if pagename == "HomePage" {
//                    Text("This is new page!")
//                        .navigationTitle("Locus")
//                }
//            }
        }
        .appBackground()
        .navigationBarBackButtonHidden(true)
    }
    
    // MARK: - Subviews
    private var headerView: some View {
        HStack {
            Text("Locus")
                .font(.largeTitle.bold())
            
            Spacer()
            
                        Button(action: { promptView = true }) {
                            Image(systemName: "plus")
                                .font(.title2)
                                .padding(12)
                                .background(Color.gray.opacity(0.2))
                                .clipShape(Circle())
                        }
//            Button(action: {
//                entryToEdit = nil // nil means we are creating a NEW entry
//                showingJournalEntryView = true // This will open the sheet
//            }) {
//                Image(systemName: "plus")
//                    .font(.title2)
//                    .padding(12)
//                    .background(Color.gray.opacity(0.2))
//                    .clipShape(Circle())
//            }
            
        }
        .navigationDestination(isPresented: $promptView, destination: {
            PromptView()
        })
        .padding()
    }
    
    @ViewBuilder
    private var journalDisplayView: some View {
        // CHANGE: Check if the entries array is empty.
        if !entriesForSelectedDate.isEmpty {
            // CHANGE: Display entries in a ScrollView with cards instead of a List.
            ScrollView {
                VStack(spacing: 15) {
                    ForEach(entriesForSelectedDate) { entry in
                        Button(action: {
                            // When a card is tapped, set it as the one to edit.
                            entryToEdit = entry
                            showingJournalEntryView = true
                        }) {
                            HStack(alignment: .top, spacing: 15) {
                                Text(entry.feelingEmoji)
                                    .font(.largeTitle)
                                
                                VStack(alignment: .leading, spacing: 5) {
                                    Text(entry.text)
                                        .font(.body)
                                        .lineLimit(3)
                                        .foregroundColor(.primary)
                                    
                                    Text(entry.date, style: .time)
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                                
                                Spacer()
                            }
                            .padding()
                            .background(Material.thin) // Using a material for a nicer frosted glass effect
                            .cornerRadius(15)
                            .shadow(radius: 3, x: 0, y: 2)
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.bottom)
            }
            
        } else {
            emptyStateView
        }
    }
    
    private var emptyStateView: some View {
        VStack {
            VStack(alignment: .leading, spacing: 7) {
                Text("Oh no... Your Journal is empty!")
                    .font(.headline)
                Text("Do you want to update your day?\nClick on \"+\" to see more")
                    .font(.subheadline)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.secondary)
                
                
            }
            .padding()
            .frame(width: 350)
            .glassEffect(
                .clear
                    .tint(Color.gray.opacity(0.6))
                    .interactive(),
                in: RoundedRectangle(cornerRadius: 10)
            )
        }
    }
    
    // MARK: - Functions
    private func loadEntries(for date: Date) {
        entriesForSelectedDate = FileManagerHelper.load(from: date)
    }
}

// MARK: - 4. Journal Entry View
//struct JournalEntryView: View {
//    @Environment(\.dismiss) private var dismiss
//    let date: Date
//
//    @State private var text: String = ""
//    @State private var selectedEmoji: String = "🙂"
//
//    private let feelings = ["🙂", "😄", "😢", "😠"]
//
//    var body: some View {
//        NavigationStack {
//            ZStack {
//                Image("background")
//                    .resizable()
//                    .scaledToFill()
//                    .edgesIgnoringSafeArea(.all)
//
//                VStack(alignment: .leading, spacing: 20) {
//                    Text("How was your day?")
//                        .font(.title2.bold())
//
//                    // Emoji Selector
//                    HStack(spacing: 20) {
//                        ForEach(feelings, id: \.self) { emoji in
//                            Button(action: { selectedEmoji = emoji }) {
//                                Text(emoji)
//                                    .font(.largeTitle)
//                                    .padding()
//                                // FIX 2: This resolves the error by using a consistent background type (Color)
//                                // and changes opacity to show selection.
//                                    .background(Color.gray.opacity(selectedEmoji == emoji ? 0.4 : 0.2))
//                                    .cornerRadius(16)
//                            }
//                        }
//                    }
//
//                    // Text Editor
//                    TextEditor(text: $text)
//                        .font(.body)
//                        .padding()
//                    // FIX 2: Replaced .ultraThinMaterial with a compatible translucent color.
//                        .background(Color.gray.opacity(0.25))
//                        .cornerRadius(20)
//                        .frame(minHeight: 200)
//                }
//                .padding()
//            }
//            .navigationTitle("Your Journal")
//            .navigationBarTitleDisplayMode(.inline)
//            .toolbar {
//                ToolbarItem(placement: .navigationBarLeading) {
//                    Button(action: { dismiss() }) {
//                        Image(systemName: "chevron.left")
//                            .padding(8)
//                            .background(Color.gray.opacity(0.2))
//                            .clipShape(Circle())
//                    }
//                }
//                ToolbarItem(placement: .navigationBarTrailing) {
//                    Button(action: saveEntry) {
//                        Image(systemName: "checkmark")
//                            .padding(8)
//                            .background(Color.gray.opacity(0.2))
//                            .clipShape(Circle())
//                    }
//                }
//            }
//            .onAppear(perform: loadExistingEntry)
//        }
//    }

//    private func loadExistingEntry() {
//        if let existingEntry = FileManagerHelper.load(from: date) {
//            text = existingEntry.text
//            selectedEmoji = existingEntry.feelingEmoji
//        }
//    }
//
//    private func saveEntry() {
//        // If text is empty, delete the entry for that day
//        if text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
//            FileManagerHelper.delete(for: date)
//        } else {
//            let newEntry = JournalEntry(date: date, feelingEmoji: selectedEmoji, text: text)
//            FileManagerHelper.save(entry: newEntry)
//        }
//        dismiss()
//    }
//}

// MARK: - 5. Horizontal Calendar View
struct HorizontalCalendarView: View {
    @Binding var selectedDate: Date
    @Binding var showingFullCalendar: Bool
    
    private let calendar = Calendar.current
    
    // This computed property calculates the dates for the week of the selectedDate.
    private var weekDates: [Date] {
        guard let weekInterval = calendar.dateInterval(of: .weekOfYear, for: selectedDate) else {
            return []
        }
        var dates: [Date] = []
        for i in 0..<7 { // A week has 7 days
            if let date = calendar.date(byAdding: .day, value: i, to: weekInterval.start) {
                dates.append(date)
            }
        }
        return dates
    }
    
    var body: some View {
        HStack {
            ScrollViewReader { proxy in
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 15) {
                        ForEach(weekDates, id: \.self) { date in
                            Button(action: {
                                withAnimation {
                                    selectedDate = date
                                }
                            }) {
                                DateCell(date: date, isSelected: calendar.isDate(date, inSameDayAs: selectedDate))
                            }
                            .id(date) // ID for ScrollViewProxy
                        }
                    }
                    .padding(.horizontal)
                }
                .onAppear {
                    // Scroll to today's date on appear
                    proxy.scrollTo(startOfDay(for: selectedDate), anchor: .center)
                }
                .onChange(of: selectedDate) { _, newDate in
                    // Animate scrolling to the selected date
                    withAnimation {
                        proxy.scrollTo(startOfDay(for: newDate), anchor: .center)
                    }
                }
            }
            
            // Button to open the full calendar view
            Button(action: { showingFullCalendar = true }) {
                Image(systemName: "calendar")
                    .font(.title2)
                    .padding(12)
                    .background(Color.gray.opacity(0.2))
                    .clipShape(Circle())
            }
            .padding(.trailing)
        }
    }
    
    private func startOfDay(for date: Date) -> Date {
        calendar.startOfDay(for: date)
    }
}


struct DateCell: View {
    let date: Date
    let isSelected: Bool
    
    private var dayOfWeek: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE" // e.g., "Mon"
        return formatter.string(from: date)
    }
    
    private var dayOfMonth: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d" // e.g., "18"
        return formatter.string(from: date)
    }
    
    var body: some View {
        VStack(spacing: 8) {
            Text(dayOfWeek)
                .font(.caption)
                .foregroundColor(isSelected ? .black : .primary)
            
            Text(dayOfMonth)
                .font(.headline)
                .fontWeight(.bold)
                .padding(10)
                .background(isSelected ? Color.white : Color.clear)
                .clipShape(Circle())
                .foregroundColor(isSelected ? .black : .primary)
        }
        .padding(5)
    }
}


// MARK: - 6. Full Screen Calendar View
struct FullCalendarView: View {
    @Binding var selectedDate: Date
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack {
            DatePicker(
                "Select a date",
                selection: $selectedDate,
                displayedComponents: .date
            )
            .datePickerStyle(.graphical)
            .padding()
            
            Button("Done") {
                dismiss()
            }
            .padding()
            .frame(maxWidth: 200)
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
    }
}

// MARK: - 7. Preview
#Preview {
    MainPageView()
}


