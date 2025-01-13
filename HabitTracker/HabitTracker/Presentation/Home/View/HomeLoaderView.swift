//
//  HomeLoaderView.swift
//  HabitTracker
//
//  Created by Yasmin Mohsen on 12/01/2025.
//

import SwiftUI

struct HomeLoaderView: View {
    //MARK: - States
    @State private var opacity: Double = 0.2
    
    //MARK: - Body
    var body: some View {
        LazyVStack(alignment: .leading, spacing: 10) {
            ForEach(0..<5) { _ in
                RoundedRectangle(cornerRadius: 24)
                    .fill(Color("lightGray"))
                    .frame(height: 80)
                    .setShimmerEffect(opacity: $opacity)
            }
        }.padding([.top], 10)
            .onAppear {
                self.opacity = 0.2
            }
    }
}

#Preview {
    HomeLoaderView()
}
