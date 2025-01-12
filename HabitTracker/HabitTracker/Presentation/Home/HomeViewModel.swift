//
//  HomeViewModel.swift
//  HabitTracker
//
//  Created by Yasmin Mohsen on 12/01/2025.
//

import Foundation

@MainActor
final class HomeViewModel: ObservableObject {
    @Published var requestState: RequestState = .non
    @Published var habits: [Habit] = []
    
    let addingHabitUseCase: IAddingHabitUseCase
    let updatingHabitUseCase: IUpdatingHabitUseCase
    let fetchingHabitsUseCase: IFetchingHabitsUseCase
    let deletingHabitUseCase: IDeletingHabitUseCase
    
    init(addingHabitUseCase: IAddingHabitUseCase, updatingHabitUseCase: IUpdatingHabitUseCase, fetchingHabitsUseCase: IFetchingHabitsUseCase, deletingHabitUseCase: IDeletingHabitUseCase) {
        self.addingHabitUseCase = addingHabitUseCase
        self.updatingHabitUseCase = updatingHabitUseCase
        self.fetchingHabitsUseCase = fetchingHabitsUseCase
        self.deletingHabitUseCase = deletingHabitUseCase
        Task { await fetchingHabits() }
    }
    
    func addingHabit(habit: Habit) async {
        requestState = .loading
        let result = await addingHabitUseCase.execute(habit: habit)
        switch result {
        case .success():
                self.habits.append(habit)
                self.habits = self.habits.sorted { $0.progress > $1.progress }
                requestState = .success
        case .failure(let error):
            requestState = .failure(msg: error.localizedDescription)
        }
    }
    
    func updatingHabit(habit: Habit) async {
       requestState = .loading
        let result = await updatingHabitUseCase.execute(habit: habit)
        switch result {
        case .success():
           requestState = .success
           await fetchingHabits()
        case .failure(let error):
           requestState = .failure(msg: error.localizedDescription)
        }
    }
    
    func fetchingHabits() async {
        requestState = .loading
        let result = await fetchingHabitsUseCase.execute()
        switch result {
        case .success(let habits):
                self.habits.removeAll()
                self.habits = habits.sorted { $0.progress > $1.progress }
                requestState = .success
        case .failure(let error):
          requestState = .failure(msg: error.localizedDescription)
        }
    }
    func deletingHabit(habit: Habit) async {
      requestState = .loading
        let result = await deletingHabitUseCase.execute(habit: habit)
        self.habits.removeAll(where: {$0.id == habit.id})
        switch result {
        case .success():
          requestState = .success
        case .failure(let error):
           requestState = .failure(msg: error.localizedDescription)
        }
    }
}
