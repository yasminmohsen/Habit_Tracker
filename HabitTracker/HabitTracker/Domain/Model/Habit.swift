//
//  Habit.swift
//  HabitTracker
//
//  Created by Yasmin Mohsen on 12/01/2025.
//

import Foundation

struct Habit: Identifiable, Codable {
    var id: String = "\(UUID())"
    var name: String
    var progress: Int
    var isCompleted: Bool {
       progress == 100
    }
    let date: Date
}
