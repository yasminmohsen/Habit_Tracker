//
//  HabitCardDetails.swift
//  HabitTracker
//
//  Created by Yasmin Mohsen on 12/01/2025.
//

import SwiftUI

struct HabitCardDetails: View {
    //MARK: - States
    @State private var progress: Double = 0.0
    @State private var showAlert = false
    
    //MARK: - Bindings
    @Binding var habit: Habit?
    @Binding var shouldDeleteHabit: Bool
    @Binding var showHabitDetails: Bool
    @Binding var shouldUpdateHabitDetails: Bool
    @Binding var showCompletedProgressMsg: Bool
   
    //MARK: - View
    var body: some View {
        ZStack {
            Color.black.opacity(0.5).ignoresSafeArea()
            VStack {
                HStack {
                    ///Delete habit action
                    Button(action: {
                        showAlert = true
                    }, label: {
                        Image(systemName: "trash.circle.fill")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundStyle(.red)
                            .padding(.all)
                    })
                    Spacer()
                }
                ///Habit name
                Text("\(habit?.name ?? "Habit")")
                    .font(.system(size: 20, weight: .semibold))
                    .padding(.all, 24)
                ///Habit Progress
                Slider(value: $progress, in: 0...100)
                    .padding(.horizontal, 24)
                    .tint(.green)
                Text("You have achieved \(progress, specifier: "%.0f")% of your habit!")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundStyle(Color.black)
                    .padding(.all, 8)
                HStack {
                    /// Mark as completed button
                    Button {
                        habit?.progress = 100
                        showHabitDetails = false
                        shouldUpdateHabitDetails = true
                        showCompletedProgressMsg = true
                    } label: {
                        Text("Mark as completed")
                            .font(.system(size: 14, weight: .semibold))
                            .minimumScaleFactor(0.5)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                    }.buttonStyle(PlainButtonStyle())
                        .frame(height: 48)
                        .background(Color("CustomGreen"))
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                    Spacer()
                    /// Done button
                    Button {
                        showHabitDetails = false
                        shouldUpdateHabitDetails = true
                        showCompletedProgressMsg =  habit?.progress == 100
                    } label: {
                        Text("Done")
                            .font(.system(size: 14, weight: .semibold))
                            .minimumScaleFactor(0.5)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                    }.buttonStyle(PlainButtonStyle())
                        .frame(height: 48)
                        .background(.orange.opacity(0.8))
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                }.padding(.all, 16)
            }.background(RoundedRectangle(cornerRadius: 12).fill(Color.white))
                .padding(.horizontal, 16)
                .cornerRadius(18)
        }.alert("", isPresented: $showAlert, actions: { // Deleting alert
            Button("Yes") {
                shouldDeleteHabit = true
                showHabitDetails = false
                showAlert = false
            }
            Button("Dismiss", role: .cancel) {
                print("User dismissed the alert")
                showAlert = false
            }
        }, message: {
            Text("Are you sure you want to delete this habit?")
        })
        ///LifeCycle methods
        .onAppear {
            progress = Double(habit?.progress ?? 0) 
        }
        ///Change observer
        .onChange(of: progress) { _,_ in
            habit?.progress = Int(progress)
        }
    }
}

#Preview {
    HabitCardDetails(habit: Binding.constant(Habit(id: "", name: "drink water", progress: 20, date: .now)), shouldDeleteHabit: Binding.constant(false), showHabitDetails: Binding.constant(false), shouldUpdateHabitDetails: Binding.constant(false), showCompletedProgressMsg: Binding.constant(false))
}
