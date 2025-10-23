//
//  JournalEntry.swift
//  Locus
//
//  Created by Hafiz Rahmadhani on 21/10/25.
//

import Foundation


struct JournalEntry: Codable, Identifiable, Hashable {
    var id: UUID = UUID()
    var date: Date
    var feelingEmoji: String
    var text: String
}

