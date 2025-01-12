//
//  LoginWithEmailUseCase.swift
//  HabitTracker
//
//  Created by Yasmin Mohsen on 11/01/2025.
//

import Foundation

protocol ILoginWithEmailUseCase {
    func execute(email: String, password: String) async -> Result<User, Error>
}

struct LoginWithEmailUseCase: ILoginWithEmailUseCase {
    private (set) var loginRepo: LoginRepository
    
    func execute(email: String, password: String) async -> Result<User, Error> {
        do {
            let user = try await loginRepo.login(email: email, password: password)
            return .success(user)
        } catch(let error) {
            return .failure(error)
        }
    }
}
