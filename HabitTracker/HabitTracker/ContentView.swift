//
//  ContentView.swift
//  HabitTracker
//
//  Created by Yasmin Mohsen on 11/01/2025.
//

import SwiftUI
import FirebaseAuth

struct ContentView: View {
    @State private var path = [String]()
    init() {
            UINavigationBar.setAnimationsEnabled(false)
        }
    var body: some View {
        NavigationStack(path: $path) {
            ZStack {
                Color("CustomGreen").ignoresSafeArea()
                Text("Habit Tracker")
                    .font(.system(size: 40))
                    .fontWeight(.bold)
                    .foregroundStyle(Color("lightYellow"))
            }.navigationDestination(for: String.self, destination: {
                if $0 == AppScreen.loginScreen.rawValue {
                    LoginWithEmailView(path: $path)
                      
                } else {
                    HomeView(path: $path)
                       
                }
            })
        }
        .onAppear() {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                if let user = DatabaseManager.shared.getCurrentUserID() {
                    path.append(AppScreen.homeScreen.rawValue)
                } else {
                    path.append(AppScreen.loginScreen.rawValue)
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
