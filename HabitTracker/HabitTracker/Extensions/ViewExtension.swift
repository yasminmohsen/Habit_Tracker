//
//  ViewExtension.swift
//  HabitTracker
//
//  Created by Yasmin Mohsen on 12/01/2025.
//

import Foundation
import SwiftUI

extension View {
    func setShimmerEffect(opacity: Binding<Double>) -> some View {
        self.modifier(ShimmerEffect(opacity: opacity))
    }
}
