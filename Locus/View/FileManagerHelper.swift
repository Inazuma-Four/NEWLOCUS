//
//  FileManagerHelper.swift
//  Locus
//
//  Created by Hafiz Rahmadhani on 21/10/25.
//

import Foundation

class FileManagerHelper {
    
    private static func getDocumentsDirectory() -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
    
    private static func fileURL(for date: Date) -> URL {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let dateString = formatter.string(from: date)
        return getDocumentsDirectory().appendingPathComponent("\(dateString).json")
    }
    
    static func save(entries: [JournalEntry], for date: Date) {
        let url = fileURL(for: date)
        do {
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
    
    static func load(from date: Date) -> [JournalEntry] {
        let url = fileURL(for: date)
        if FileManager.default.fileExists(atPath: url.path) {
            do {
                let data = try Data(contentsOf: url)
                let entries = try JSONDecoder().decode([JournalEntry].self, from: data)
                print("✅ Loaded \(entries.count) entries.")
                return entries.sorted { $0.date > $1.date }
            } catch {
                print("❌ Failed to load or decode entries: \(error.localizedDescription)")
            }
        }
        return []
    }
}
