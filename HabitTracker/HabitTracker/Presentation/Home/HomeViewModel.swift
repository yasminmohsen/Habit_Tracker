//
//  HomeViewModel.swift
//  HabitTracker
//
//  Created by Yasmin Mohsen on 12/01/2025.
//

import Foundation

final class HomeViewModel: ObservableObject {
    @Published var requestState: RequestState = .non
    @Published var habits: [Habit] = []
    let h = [Habit(id: "0", name: "Drink water", progress: 80, date: .now), Habit(id: "1", name: " watchTv", progress: 100, date: .now), Habit(id: "3", name: "Run", progress: 50, date: .now)]
    
    let addingHabitUseCase: IAddingHabitUseCase
    let updatingHabitUseCase: IUpdatingHabitUseCase
    let fetchingHabitsUseCase: IFetchingHabitsUseCase
    let deletingHabitUseCase: IDeletingHabitUseCase
    
    init(addingHabitUseCase: IAddingHabitUseCase, updatingHabitUseCase: IUpdatingHabitUseCase, fetchingHabitsUseCase: IFetchingHabitsUseCase, deletingHabitUseCase: IDeletingHabitUseCase) {
        self.addingHabitUseCase = addingHabitUseCase
        self.updatingHabitUseCase = updatingHabitUseCase
        self.fetchingHabitsUseCase = fetchingHabitsUseCase
        self.deletingHabitUseCase = deletingHabitUseCase
        self.habits = h
    }
    
    func addingHabit(habit: Habit) async {
        requestState = .loading
        let result = await addingHabitUseCase.execute(habit: habit)
        switch result {
        case .success():
            await MainActor.run(body: { requestState = .success })
        case .failure(let error):
            await MainActor.run(body: { requestState = .failure(msg: error.localizedDescription)})
        }
    }
    
    func updatingHabit(habit: Habit) async {
        requestState = .loading
        let result = await updatingHabitUseCase.execute(habit: habit)
        switch result {
        case .success():
            await MainActor.run(body: { requestState = .success })
        case .failure(let error):
            await MainActor.run(body: { requestState = .failure(msg: error.localizedDescription)})
        }
    }
    
    func fetchingHabits(habit: Habit) async {
        requestState = .loading
        let result = await fetchingHabitsUseCase.execute()
        switch result {
        case .success(let habits):
            await MainActor.run(body: {
                self.habits = habits
                requestState = .success
            })
        case .failure(let error):
            await MainActor.run(body: { requestState = .failure(msg: error.localizedDescription)})
        }
    }
    func deletingHabit(habitIndex: Int) async {
        requestState = .loading
        let result = await deletingHabitUseCase.execute(habit: habits[habitIndex])
        self.habits.remove(at: habitIndex)
        switch result {
        case .success():
            await MainActor.run(body: { requestState = .success })
        case .failure(let error):
            await MainActor.run(body: { requestState = .failure(msg: error.localizedDescription)})
        }
    }
}
