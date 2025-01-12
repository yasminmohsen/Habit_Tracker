//
//  RequestState.swift
//  HabitTracker
//
//  Created by Yasmin Mohsen on 11/01/2025.
//

import Foundation

enum RequestState {
    case non, loading, success, failure(msg: String)
}
