//
//  LoginDataRepository.swift
//  HabitTracker
//
//  Created by Yasmin Mohsen on 11/01/2025.
//

import Foundation
import FirebaseAuth

final class LoginDataRepository: LoginRepository {
    
    /// Sign up Function using FirebaseAuth[ email and password]
    /// - Parameters:
    ///   - email: user's email
    ///   - password: user's password
    /// - Returns: created user
    func signUp(email: String, password: String) async throws -> User {
        let result = try await Auth.auth().createUser(withEmail: email, password: password)
        let user = User(userId: result.user.uid, userEmail: result.user.email)
        DatabaseManager.shared.saveUserID(userID: user.userId)
        return user
    }
    
    /// Login Function using FirebaseAuth[ email and password]
    /// - Parameters:
    ///   - email: user's email
    ///   - password: user's password
    /// - Returns: logged in user
    func login(email: String, password: String) async throws -> User {
        let result = try await Auth.auth().signIn(withEmail: email, password: password)
        let user = User(userId: result.user.uid, userEmail: result.user.email)
        DatabaseManager.shared.saveUserID(userID: user.userId)
        return user
    }
    
    /// Logout Function
    func signOut() throws {
        try Auth.auth().signOut()
        DatabaseManager.shared.deleteUser()
    }
}
