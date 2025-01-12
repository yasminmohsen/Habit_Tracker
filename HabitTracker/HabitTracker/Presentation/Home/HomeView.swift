//
//  HomeView.swift
//  HabitTracker
//
//  Created by Yasmin Mohsen on 11/01/2025.
//

import SwiftUI
import Firebase

struct HomeView: View {
    @Binding var path: [String]
    @State var shouldDeleteHabit: Bool = false
    @State var showHabitDetails: Bool = false
    @State var currentIndex: Int = 0
    @StateObject var homeViewModel = HomeViewModel(addingHabitUseCase: AddingHabitUseCase(habitRepo: HabitDataRepository()), updatingHabitUseCase: UpdatingHabitUseCase(habitRepo: HabitDataRepository()), fetchingHabitsUseCase: FetchingHabitsUseCase(habitRepo: HabitDataRepository()), deletingHabitUseCase: DeletingHabitUseCase(habitRepo: HabitDataRepository()))
    var body: some View {
        ZStack(alignment: .top) {
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
                    Button(action: {
                        
                    }, label: {
                        Image(systemName: "plus.app.fill")
                            .resizable()
                            .frame(width: 40, height:  40)
                            .foregroundStyle(Color("CustomGreen"))
                    })
                }
                ScrollView {
                    VStack(content: {
                        ForEach(homeViewModel.habits.indices, id: \.self) { index in
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color("lightYellow").opacity(0.6))
                                .frame(height: 100)
                                .overlay {
                                    HStack(content: {
                                        Text("\(homeViewModel.habits[index].name)")
                                            .foregroundStyle(Color.black)
                                            .font(.system(size: 18, weight: .semibold))
                                           
                                        Spacer()
                                        if homeViewModel.habits[index].isCompleted {
                                            Image(systemName: "checkmark.shield.fill")
                                                .resizable()
                                                .frame(width: 24, height: 24)
                                                .foregroundStyle(Color("CustomGreen"))

                                        } else {
                                            ZStack {
                                                Circle()
                                                    .stroke(lineWidth:3 )
                                                    .foregroundColor(.white)
                                                    .frame(width: 24, height: 24)
                                
                                                Circle()
                                                    .trim(from: 0.0, to: Double(homeViewModel.habits[index].progress) / 100.0)
                                                    .stroke(style: StrokeStyle(lineWidth: 3, lineCap: .round, lineJoin: .round))
                                                    .foregroundColor(.cyan)
                                                    .frame(width:24, height: 24)
                                
                                                    .rotationEffect(.degrees(-90))
                                            }
                                        }
                    
                                    }) .padding(.horizontal, 16)
                                }.onTapGesture {
                                    currentIndex = index
                                   showHabitDetails = true
                                }
                        }
                    })
                }
            }.padding(.horizontal, 20)
            if homeViewModel.habits.isEmpty {
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
            if showHabitDetails {
                HabitCardDetails(habit: $homeViewModel.habits[currentIndex], shouldDeleteHabit: $shouldDeleteHabit, showHabitDetails: $showHabitDetails)
            }
        }.navigationBarBackButtonHidden()
            .onChange(of: shouldDeleteHabit) { _,_ in
                if shouldDeleteHabit {
                    Task {
                        await homeViewModel.deletingHabit(habitIndex: currentIndex)
                        shouldDeleteHabit.toggle()
                    }
                }
            }
    }
}

#Preview {
    HomeView(path: Binding.constant([]))
}
