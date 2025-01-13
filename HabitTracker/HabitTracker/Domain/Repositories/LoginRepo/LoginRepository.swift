//
//  LoginRepository.swift
//  HabitTracker
//
//  Created by Yasmin Mohsen on 11/01/2025.
//

import Foundation

protocol LoginRepository {
    func signUp(email: String, password: String) async throws -> User
    func login(email: String, password: String) async throws -> User
    func signOut() throws
}
