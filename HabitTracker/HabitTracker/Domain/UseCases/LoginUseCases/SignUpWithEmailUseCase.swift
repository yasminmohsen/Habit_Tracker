//
//  SignUpWithEmailUseCase.swift
//  HabitTracker
//
//  Created by Yasmin Mohsen on 11/01/2025.
//

import Foundation

protocol ISignUpWithEmailUseCase {
    func execute(email: String, password: String) async -> Result<User, Error>
}

struct SignUpWithEmailUseCase: ISignUpWithEmailUseCase {
    private (set) var loginRepo: LoginRepository
    
    func execute(email: String, password: String) async -> Result<User, Error> {
        do {
            let user = try await loginRepo.signUp(email: email, password: password)
            return .success(user)
        } catch(let error) {
            return .failure(error)
        }
    }
}
