//
//  FetchingHabitsUseCase.swift
//  HabitTracker
//
//  Created by Yasmin Mohsen on 12/01/2025.
//

import Foundation

protocol IFetchingHabitsUseCase {
    func execute() async -> Result<[Habit], Error>
}

struct FetchingHabitsUseCase : IFetchingHabitsUseCase {
    private (set) var habitRepo: HabitRepository
    
    func execute() async -> Result<[Habit], Error> {
        do {
            let habits = try await habitRepo.fetchHabits()
            return .success(habits)
        } catch(let error) {
            return .failure(error)
        }
    }
}

