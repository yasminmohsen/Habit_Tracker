//
//  AddNewHabitView.swift
//  HabitTracker
//
//  Created by Yasmin Mohsen on 12/01/2025.
//

import SwiftUI

struct AddNewHabitView: View {
    //MARK: - State
    @State private var habitName = ""
    @State private var progress  = 0.0
    @State private var showInputErrorMessageAlert: Bool = false
    @State private var showRequestErrorMessageAlert: Bool = false
    @State private var showLoader: Bool = false
    @State private var errorMsg: String = ""
    
    //MARK: - ObservedObjects
    @ObservedObject var homeViewModel: HomeViewModel
    
    //MARK: - Bindings
    @Binding var isPresented: Bool
   
    //MARK: - View
    var body: some View {
            NavigationView {
                Form {
                    Section(header: Text("Habit Details")) {
                        ///Habit name textField
                        TextField("Habit Name", text: $habitName)
                        HStack {
                            ///Habit progress
                            Text("Progress: \(progress, specifier: "%.0f")")
                            Slider(value: $progress, in: 0...100)
                                .padding(.horizontal, 24)
                                .tint(.green)
                        }
                    }
                }.alert("Enter Habit name", isPresented: $showInputErrorMessageAlert, actions: {
                    Button("Ok", role:.cancel) {
                        showInputErrorMessageAlert = false
                    }
                }).alert("\(errorMsg)", isPresented: $showRequestErrorMessageAlert, actions: {
                    Button("Ok", role:.cancel) {
                        showRequestErrorMessageAlert = false
                    }
                })
                .navigationTitle("Add New Habit")
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cancel") {
                            isPresented = false
                        }
                    }
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Save") {
                            if habitName.isEmpty {
                                showInputErrorMessageAlert = true
                            } else {
                                saveHabit()
                               
                            }
                        }
                    }
                }
                if showLoader {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                }
            }
        }
    private func saveHabit() {
        let habit = Habit(name: habitName, progress: Int(progress), date: .now)
        Task {
              await homeViewModel.addingHabit(habit: habit)
            }
        }
    }


