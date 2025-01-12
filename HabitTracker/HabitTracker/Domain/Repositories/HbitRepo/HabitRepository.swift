//
//  HabitRepository.swift
//  HabitTracker
//
//  Created by Yasmin Mohsen on 12/01/2025.
//

import Foundation

protocol HabitRepository {
    func addHabit(habit: Habit) async throws
    func updateHabit(habit: Habit) async throws
    func deleteHabit(habit: Habit) async throws
    func fetchHabits() async throws -> [Habit]
}
