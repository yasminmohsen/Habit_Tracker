//
//  DeletingHabitUseCase.swift
//  HabitTracker
//
//  Created by Yasmin Mohsen on 12/01/2025.
//

import Foundation

protocol IDeletingHabitUseCase {
    func execute(habit: Habit) async -> Result<Void, Error>
}

struct DeletingHabitUseCase: IDeletingHabitUseCase {
    private (set) var habitRepo: HabitRepository
    
    func execute(habit: Habit) async -> Result<Void, Error> {
        do {
            let _ = try await habitRepo.deleteHabit(habit: habit)
            return .success(())
        } catch(let error) {
            return .failure(error)
        }
    }
}
