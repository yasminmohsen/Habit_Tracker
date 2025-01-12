//
//  AddingHabitUseCase.swift
//  HabitTracker
//
//  Created by Yasmin Mohsen on 12/01/2025.
//

import Foundation

protocol IAddingHabitUseCase {
    func execute(habit: Habit) async -> Result<Void, Error>
}

struct AddingHabitUseCase: IAddingHabitUseCase {
    private (set) var habitRepo: HabitRepository
    
    func execute(habit: Habit) async -> Result<Void, Error> {
        do {
            let _ = try await habitRepo.addHabit(habit: habit)
            return .success(())
        } catch(let error) {
            return .failure(error)
        }
    }
}
