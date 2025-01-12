//
//  HomeView.swift
//  HabitTracker
//
//  Created by Yasmin Mohsen on 11/01/2025.
//

import SwiftUI

struct HomeView: View {
    @Binding var path: [String]
    var body: some View {
        ZStack {
            Button("logout") {
                path.removeLast()
            }
        }.navigationBarBackButtonHidden()
    }
}

#Preview {
    HomeView(path: Binding.constant([]))
}
