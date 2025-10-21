//
//  FileManagerHelper.swift
//  Locus
//
//  Created by Hafiz Rahmadhani on 21/10/25.
//

import Foundation

class FileManagerHelper {
    
    // Gets the URL for the app's documents directory.
    private static func getDocumentsDirectory() -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
    
    // Creates a unique filename for each entry based on its date.
    private static func fileURL(for date: Date) -> URL {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let dateString = formatter.string(from: date)
        return getDocumentsDirectory().appendingPathComponent("\(dateString).json")
    }
    
    // CHANGE: This function now saves an ARRAY of entries.
        static func save(entries: [JournalEntry], for date: Date) {
            let url = fileURL(for: date)
            do {
                // If the array is empty, delete the file for that day.
                if entries.isEmpty {
                    if FileManager.default.fileExists(atPath: url.path) {
                       try FileManager.default.removeItem(at: url)
                       print("🗑️ File deleted as there are no more entries for this date.")
                    }
                    return
                }
                
                let data = try JSONEncoder().encode(entries)
                try data.write(to: url, options: [.atomic, .completeFileProtection])
                print("✅ \(entries.count) entries saved for date.")
            } catch {
                print("❌ Failed to save entries: \(error.localizedDescription)")
            }
        }
        
        // CHANGE: This function now loads and returns an ARRAY of entries.
        static func load(from date: Date) -> [JournalEntry] {
            let url = fileURL(for: date)
            if FileManager.default.fileExists(atPath: url.path) {
                do {
                    let data = try Data(contentsOf: url)
                    // Decode an array of JournalEntry instead of a single one.
                    let entries = try JSONDecoder().decode([JournalEntry].self, from: data)
                    print("✅ Loaded \(entries.count) entries.")
                    // Sort entries by date, newest first
                    return entries.sorted { $0.date > $1.date }
                } catch {
                    print("❌ Failed to load or decode entries: \(error.localizedDescription)")
                }
            }
            // If no file exists, return an empty array.
            return []
        }
    
    // Deletes a journal entry for a specific date
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
}
