//
//  HabitDataRepository.swift
//  HabitTracker
//
//  Created by Yasmin Mohsen on 12/01/2025.
//

import Foundation
import Firebase

final class HabitDataRepository: HabitRepository {
    let currentUserId = DatabaseManager.shared.getCurrentUserID()
    let db = Firestore.firestore()
    let usersCollectionID = "users"
    let habitsCollectionID = "habits"
    
    func addHabit(habit: Habit) async throws {
        guard let currentUserId = currentUserId else { return }
        try await db.collection(usersCollectionID)
            .document(currentUserId)
            .collection(habitsCollectionID)
            .addDocument(data: [
                "name": habit.name,
                "progress": habit.progress,
                "date": Timestamp(date: habit.date)
            ])
    }
    
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
    
    func deleteHabit(habit: Habit) async throws {
        guard let currentUserId = currentUserId else { return }
        try await db.collection(usersCollectionID)
            .document(currentUserId)
            .collection(habitsCollectionID)
            .document(habit.id)
            .delete()
    }
    
    func fetchHabits() async throws -> [Habit] {
        guard let currentUserId = currentUserId else { return [] }
       return try await db.collection(usersCollectionID)
            .document(currentUserId)
            .collection(habitsCollectionID)
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
