//
//  HabitDataRepository.swift
//  HabitTracker
//
//  Created by Yasmin Mohsen on 12/01/2025.
//

import Foundation
import Firebase

final class HabitDataRepository: HabitRepository {
    //MARK: - Properties
    private let currentUserId = DatabaseManager.shared.getCurrentUserID()
    private let db = Firestore.firestore()
    private let usersCollectionID = "users"
    private let habitsCollectionID = "habits"
    
    //MARK: - Helpers
    /// Add new habit to Firestore  database
    /// - Parameter habit: new habit
    func addHabit(habit: Habit) async throws {
        guard let currentUserId = currentUserId else { return }
        
        try await db.collection(usersCollectionID)
            .document(currentUserId)
            .collection(habitsCollectionID)
            .document(habit.id)
            .setData([
                "name": habit.name,
                "progress": habit.progress,
                "date": Timestamp(date: habit.date)
            ])
    }
    
    /// Update existing habit
    /// - Parameter habit: new updated habit
    func updateHabit(habit: Habit) async throws {
        guard let currentUserId = currentUserId else { return }
        
        try await db.collection(usersCollectionID)
            .document(currentUserId)
            .collection(habitsCollectionID)
            .document(habit.id)
            .updateData([
                "name": habit.name,
                "progress": habit.progress,
                "date": Timestamp(date: habit.date)
            ])
    }
    
    /// Delete habit using id
    /// - Parameter habit: deleted habit
    func deleteHabit(habit: Habit) async throws {
        guard let currentUserId = currentUserId else { return }
        
        try await db.collection(usersCollectionID)
            .document(currentUserId)
            .collection(habitsCollectionID)
            .document(habit.id)
            .delete()
    }
    
    /// Fetching habits collection
    /// - Returns: collection of habits
    func fetchHabits() async throws -> [Habit] {
        guard let currentUserId = currentUserId else { return [] }
        // setting date limitations to retrieve only today's habits
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: Date())
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)?.addingTimeInterval(-1)
        let startTimestamp = Timestamp(date: startOfDay)
        let endTimestamp = Timestamp(date: endOfDay ?? startOfDay)
        
        return try await db.collection(usersCollectionID)
            .document(currentUserId)
            .collection(habitsCollectionID)
            .whereField("date", isGreaterThanOrEqualTo: startTimestamp)
            .whereField("date", isLessThanOrEqualTo: endTimestamp)
            .getDocuments()
            .documents.compactMap { document -> Habit? in
                let data = document.data()
                guard let name = data["name"] as? String,
                      let progress = data["progress"] as? Int,
                      let date = (data["date"] as? Timestamp)?.dateValue() else { return nil }
                return Habit(id: document.documentID, name: name, progress: progress, date: date)
            }
    }
}
