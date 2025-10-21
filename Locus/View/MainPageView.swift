//
//  ContentView.swift
//  ActivityTesting1
//
//  Created by Mohsin Amir Siddiqui on 21/10/25.
//

import SwiftUI

struct MainPageView: View {
    @State private var selectedDate = Date()
    @State private var currentEntry: JournalEntry?
    @State private var promptView = false
    @State private var showingFullCalendar = false
    @State private var entriesForSelectedDate: [JournalEntry] = []
    @State private var entryToEdit: JournalEntry?
    @State private var showingJournalEntryView = false
    @State private var showingJournalPromptView = false
    @State private var navPath = NavigationPath()
    
    var body: some View {
        NavigationStack(path: $navPath) {
            ZStack {
                VStack(spacing: 0) {
                    headerView

                    HorizontalCalendarView(selectedDate: $selectedDate, showingFullCalendar: $showingFullCalendar)
                        .padding(.bottom, 20)
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
                    .presentationDetents([.fraction(0.6)])
                    .presentationDragIndicator(.visible)
                    .presentationCornerRadius(40)
            }
            .navigationDestination(isPresented: $showingJournalEntryView) {
                if let entry = entryToEdit {
                    JournalView(
                        entryToEdit: entry,
                        feelingEmoji: entry.feelingEmoji,
                        
                        onSaveComplete: {
                            loadEntries(for: selectedDate)
                        }
                    )
                }
            }
            .navigationDestination(isPresented: $showingJournalPromptView) {
                            if let entry = entryToEdit {
                                JournalPromptView(
                                    entryToEdit: entry,
                                    onSaveComplete: {
                                        loadEntries(for: selectedDate)
                                    }
                                )
                            }
                        }
        }
        .appBackground()
        .navigationBarBackButtonHidden(true)
        .onAppear{
            NotificationManager.shared.checkNotifPermission()
            NotificationManager.shared.addWeeklyNotifications()
        }
    }
    
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
                    .foregroundStyle(Color.primary)
                    .clipShape(Circle())
            }
        }
        .navigationDestination(isPresented: $promptView, destination: {
            PromptView()
        })
        .padding()
    }
    
    @ViewBuilder
    private var journalDisplayView: some View {
        if !entriesForSelectedDate.isEmpty {
            ScrollView {
                VStack(spacing: 15) {
                    ForEach(entriesForSelectedDate) { entry in
                        Button(action: {
                            entryToEdit = entry
                            if entry.text.hasPrefix("Prompt: ") {
                                showingJournalPromptView = true
                            } else {
                                showingJournalEntryView = true
                            }
                        }) {
                            HStack(alignment: .top, spacing: 15) {
                                Image(getImageName(for: entry.feelingEmoji))
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 45, height: 45)
                                    //.background(.ultraThinMaterial)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                
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
                            .background(Material.thin)
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
    
    private func loadEntries(for date: Date) {
        entriesForSelectedDate = FileManagerHelper.load(from: date)
    }
    
    private func getImageName(for emoji: String) -> String {
        switch emoji {
        case "😡": return "Image 1"
        case "😢": return "Image 2"
        case "😊": return "Image 3"
        case "😐": return "Image 4"
        default:
            return "Image 3"
        }
    }
}

struct HorizontalCalendarView: View {
    @Binding var selectedDate: Date
    @Binding var showingFullCalendar: Bool
    
    private let calendar = Calendar.current
    private var weekDates: [Date] {
        guard let weekInterval = calendar.dateInterval(of: .weekOfYear, for: selectedDate) else {
            return []
        }
        var dates: [Date] = []
        for i in 0..<7 {
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
                            let isFutureDate = calendar.compare(date, to: Date(), toGranularity: .day) == .orderedDescending
                            
                            Button(action: {
                                withAnimation {
                                    selectedDate = date
                                }
                            }) {
                                DateCell(date: date,
                                         isSelected: calendar.isDate(date, inSameDayAs: selectedDate),
                                         isFuture: isFutureDate
                                )
                            }
                            .disabled(isFutureDate)
                            .id(date)
                        }
                    }
                    .padding(.horizontal)
                }
                .onAppear {
                    proxy.scrollTo(startOfDay(for: selectedDate), anchor: .center)
                }
                .onChange(of: selectedDate) { _, newDate in
                    withAnimation {
                        proxy.scrollTo(startOfDay(for: newDate), anchor: .center)
                    }
                }
            }
    
            Button(action: { showingFullCalendar = true }) {
                Image(systemName: "calendar")
                    .font(.title2)
                    .padding(12)
                    .background(Color.gray.opacity(0.2))
                    .foregroundStyle(Color.primary)
                    .clipShape(Circle())
            }
            .padding(.trailing)
            .padding(.top, 10)
        }
    }
    
    private func startOfDay(for date: Date) -> Date {
        calendar.startOfDay(for: date)
    }
}


struct DateCell: View {
    @Environment(\.colorScheme) private var colorScheme
    let date: Date
    let isSelected: Bool
    let isFuture: Bool
    
    private var dayOfWeek: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE"
        return formatter.string(from: date)
    }
    
    private var dayOfMonth: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter.string(from: date)
    }
    
    var body: some View {
        VStack(spacing: 8) {
            Text(dayOfWeek)
                .font(.caption)
                .foregroundColor(isSelected ? .primary : (isFuture ? .gray.opacity(0.5) : .secondary))
            
            Text(dayOfMonth)
                .font(.headline)
                .fontWeight(.bold)
                .padding(10)
                .background(isSelected ? Color.primary : Color.clear)
                .clipShape(Circle())
                .foregroundColor(
                    isSelected ? (colorScheme == .dark ? Color.black : Color.white) : (isFuture ? .gray.opacity(0.5) : .primary)
                )
        }
        .padding(5)
    }
}

struct FullCalendarView: View {
    @Binding var selectedDate: Date
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        VStack {
            DatePicker(
                "Select a date",
                selection: $selectedDate,
                in: ...Date(),
                displayedComponents: .date
            )
            .datePickerStyle(.graphical)
            .tint(Color.primary)
            .padding()
            
            Button(action : {
                dismiss()
            }) {
                Text("Done")
                    .foregroundColor(colorScheme == .dark ? .black : .white)
                    .frame(width: 300, height: 50)
            }
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
            .contentShape(RoundedRectangle(cornerRadius: 16))
            .cornerRadius(16)
            .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
        }
    }
}

#Preview {
    MainPageView()
}
