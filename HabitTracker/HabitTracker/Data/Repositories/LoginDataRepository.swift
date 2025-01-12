//
//  LoginDataRepository.swift
//  HabitTracker
//
//  Created by Yasmin Mohsen on 11/01/2025.
//

import Foundation
import FirebaseAuth

final class LoginDataRepository: LoginRepository {
    func signUp(email: String, password: String) async throws -> User {
        let result = try await Auth.auth().createUser(withEmail: email, password: password)
        let user = User(userId: result.user.uid, userEmail: result.user.email)
        DatabaseManager.shared.saveUserID(userID: user.userId)
        return user
    }
    
    func login(email: String, password: String) async throws -> User {
        let result = try await Auth.auth().signIn(withEmail: email, password: password)
        let user = User(userId: result.user.uid, userEmail: result.user.email)
        DatabaseManager.shared.saveUserID(userID: user.userId)
        return user
    }
    func signOut() async throws {
        try await Auth.auth().signOut()
        DatabaseManager.shared.deleteUser()
    }
}
