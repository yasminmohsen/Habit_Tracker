//
//  AddNewHabitView.swift
//  HabitTracker
//
//  Created by Yasmin Mohsen on 12/01/2025.
//

import SwiftUI

struct AddNewHabitView: View {
    @Binding var isPresented: Bool
    @State var habitName = ""
    @State var progress  = 0.0
    @ObservedObject var homeViewModel: HomeViewModel
    
    var body: some View {
            NavigationView {
                Form {
                    Section(header: Text("Habit Details")) {
                        TextField("Habit Name", text: $habitName)
                        HStack {
                            Text("Progress: \(progress, specifier: "%.0f")")
                            Slider(value: $progress, in: 0...100)
                                .padding(.horizontal, 24)
                                .tint(.green)
                        }
                    }
                }
                .navigationTitle("Add New Habit")
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cancel") {
                            isPresented = false
                        }
                    }
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Save") {
                             saveHabit()
                            isPresented = false
                        }
                    }
                }
            }
        }
    func saveHabit() {
        let habit = Habit(name: habitName, progress: Int(progress), date: .now)
        Task {
              await homeViewModel.addingHabit(habit: habit)
            }
        }
    }


