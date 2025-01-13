//
//  HomeView.swift
//  HabitTracker
//
//  Created by Yasmin Mohsen on 11/01/2025.
//

import SwiftUI
import Firebase

struct HomeView: View {
    //MARK: - States
    @State private var shouldDeleteHabit: Bool = false
    @State private var showHabitDetails: Bool = false
    @State private var currentHabit: Habit? = nil
    @State private var isPresented = false
    @State private var showLoader: Bool = false
    @State private var showErrorMessageAlert: Bool = false
    @State private var errorMsg: String = ""
    @State private var shouldUpdateHabitDetails = false
    @State private var showCompletedProgressMsg: Bool = false
    @State private var showEmptyState: Bool = false
    
    //MARK: - StateObject
    @StateObject private var homeViewModel = HomeViewModel(addingHabitUseCase: AddingHabitUseCase(habitRepo: HabitDataRepository()), updatingHabitUseCase: UpdatingHabitUseCase(habitRepo: HabitDataRepository()), fetchingHabitsUseCase: FetchingHabitsUseCase(habitRepo: HabitDataRepository()), deletingHabitUseCase: DeletingHabitUseCase(habitRepo: HabitDataRepository()))
    
    //MARK: - Bindings
    @Binding var path: [String]
    
    //MARK: - View
    var body: some View {
        ZStack(alignment: .center) {
            Color.white
            VStack {
                HStack {
                    VStack(alignment: .leading) {
                        Text("Your Habits")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .frame(alignment: .leading)
                            .foregroundStyle(Color.black)
                            .multilineTextAlignment(.leading)
                        Text("For Today")
                            .font(.title)
                            .fontWeight(.light)
                            .foregroundStyle(Color.gray)
                            .frame(alignment: .leading)
                            .multilineTextAlignment(.leading)
                            .padding(.leading, 8)
                    }
                    Spacer()
                    ///Adding new habit button
                    Button(action: {
                        isPresented = true
                    }, label: {
                        Image(systemName: "plus.app.fill")
                            .resizable()
                            .frame(width: 35, height:  35)
                            .foregroundStyle(Color("CustomGreen"))
                    })
                }.padding(.top, 16)
                ScrollView {
                    VStack(content: {
                        /// Placeholder collection
                        if showLoader && homeViewModel.habits.isEmpty && !showEmptyState {
                            HomeLoaderView()
                        }
                        /// Habit list
                        else {
                            ForEach(homeViewModel.habits.indices, id: \.self) { index in
                                RoundedRectangle(cornerRadius: 24)
                                    .fill(Color("lightYellow").opacity(0.6))
                                    .frame(height: 80)
                                    .frame(maxHeight: 200)
                                    .overlay {
                                        HStack(content: {
                                            ///Habit name
                                            VStack(alignment: .leading, spacing: 0) {
                                                Text("\(homeViewModel.habits[index].name)")
                                                    .foregroundStyle(Color.black)
                                                .font(.system(size: 18, weight: .semibold))
                                                .multilineTextAlignment(.leading)
                                                .padding(.vertical, 8)
                                                HStack {
                                                    ///Habit progress indicator
                                                    if homeViewModel.habits[index].isCompleted {
                                                        Text("Completed!")
                                                            .font(.system(size: 10, weight: .bold))
                                                            .foregroundStyle(Color.gray)
                                                        Image(systemName: "checkmark.shield.fill")
                                                            .resizable()
                                                            .frame(width: 18, height: 18)
                                                            .foregroundStyle(Color("CustomGreen"))
                                                    } else {
                                                        Text("Progress level:")
                                                            .font(.system(size: 10, weight: .bold))
                                                            .foregroundStyle(Color.gray)
                                                        ZStack {
                                                            Circle()
                                                                .stroke(lineWidth:3 )
                                                                .foregroundColor(.white)
                                                                .frame(width: 18, height: 18)
                                                            Circle()
                                                                .trim(from: 0.0, to: Double(homeViewModel.habits[index].progress) / 100.0)
                                                                .stroke(style: StrokeStyle(lineWidth: 3, lineCap: .round, lineJoin: .round))
                                                                .foregroundColor(Color("CustomGreen"))
                                                                .frame(width:18, height: 18)
                                                                .rotationEffect(.degrees(-90))
                                                        }
                                                    }
                                                    Spacer()
                                                }.padding(.bottom, 8)
                                            }
                                            Spacer()
                                           
                                            Button {
                                                currentHabit = homeViewModel.habits[index]
                                                showHabitDetails = true
                                            } label: {
                                                Text("Edit")
                                                    .foregroundColor(Color("CustomGreen"))
                                                    .frame(width: 69, height: 32)
                                                    .font(.system(size: 12, weight: .semibold))
                                                    .background(RoundedRectangle(cornerRadius: 8, style: .continuous).fill(Color.white))
                                                    .overlay(
                                                        RoundedRectangle(cornerRadius: 8, style: .continuous)
                                                            .strokeBorder((Color("CustomGreen")), lineWidth: 2))
                                            
                                            }.buttonStyle(PlainButtonStyle())
                                            .frame(height: 28)

                                        }) .padding(.horizontal, 16)
                                      
                                    }
                            }
                        }
                    })
                }.refreshable { // For refresh habit list
                    Task { await homeViewModel.fetchingHabits() }
                }
            }.padding(.horizontal, 20)
            ///Empty state view
            if showEmptyState {
                VStack {
                    Spacer()
                    Image("emptyScreen")
                        .resizable()
                        .frame(height: 300)
                        .opacity(0.6)
                    Text("No Habits")
                        .font(.title)
                        .fontWeight(.light)
                        .foregroundStyle(Color.gray)
                    Spacer()
                }
            }
            ///Habit CardDetails view
            if showHabitDetails {
                HabitCardDetails(habit: $currentHabit, shouldDeleteHabit: $shouldDeleteHabit, showHabitDetails: $showHabitDetails, shouldUpdateHabitDetails: $shouldUpdateHabitDetails, showCompletedProgressMsg: $showCompletedProgressMsg)
            }
            if showCompletedProgressMsg {
                Color.black.opacity(0.5).ignoresSafeArea()
                VStack {
                    Text("Congratulations 🎉! You completed \"\(currentHabit?.name ?? "Habit")\" for today.")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .multilineTextAlignment(.center)
                        .padding(.all, 24)
                    Button {
                        showCompletedProgressMsg = false
                    } label: {
                        Text("Done")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                    }.buttonStyle(PlainButtonStyle())
                        .frame(height: 48)
                        .background(.orange.opacity(0.8))
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .padding(.horizontal, 24)
                        .padding(.bottom , 16)
                }.background(RoundedRectangle(cornerRadius: 12).fill(Color.white))
                    .padding(.horizontal, 16)
                    .cornerRadius(18)
            }
        }.sheet(isPresented: $isPresented, content: { // Open AddNewHabitView
            AddNewHabitView(homeViewModel: self.homeViewModel, isPresented: $isPresented)
        })
        .navigationBarBackButtonHidden()
        /// Error message alert
        .alert("", isPresented: $showErrorMessageAlert, actions: {
            Button("Ok", role:.cancel) {
                showErrorMessageAlert = false
            }
        })
        ///Change observers
        // Deleting habit
        .onChange(of: shouldDeleteHabit) { _,_ in // Deleting habit
            if shouldDeleteHabit {
                guard let currentHabit else { return }
                Task {
                    await homeViewModel.deletingHabit(habit: currentHabit)
                    shouldDeleteHabit.toggle()
                }
            }
        }
        // Updating habit
        .onChange(of: shouldUpdateHabitDetails, { _, _ in //
            if shouldUpdateHabitDetails {
                guard let currentHabit else { return }
                Task {
                    await homeViewModel.updatingHabit(habit: currentHabit)
                    shouldUpdateHabitDetails.toggle()
                }
            }
        })
        .onReceive(homeViewModel.$requestState) {
            switch $0 {
            case .loading:
                showLoader = true
            case .failure(msg: let msg):
                errorMsg = msg
                showErrorMessageAlert = true
                showLoader = false
                showEmptyState = homeViewModel.habits.isEmpty
            case .success :
                showLoader = false
                showEmptyState = homeViewModel.habits.isEmpty
            default:
                break
            }
        }
    }
}

#Preview {
    HomeView(path: Binding.constant([]))
}
