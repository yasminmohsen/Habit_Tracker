//
//  ShimmerEffect.swift
//  HabitTracker
//
//  Created by Yasmin Mohsen on 12/01/2025.
//

import Foundation
import SwiftUI

struct ShimmerEffect: ViewModifier {
    @Binding var opacity: Double
    
    func body(content: Content) -> some View {
        content
            .opacity(opacity)
            .transition(.opacity)
            .onAppear {
                let baseAnimation = Animation.easeInOut(duration: 1)
                let repeated = baseAnimation.repeatForever(autoreverses: true)
                withAnimation(repeated) {
                    $opacity.wrappedValue = 1
                }
            }
    }
}
