//
//  LogoutUseCase.swift
//  HabitTracker
//
//  Created by Yasmin Mohsen on 11/01/2025.
//

import Foundation
protocol ILogoutUseCase {
    func execute() async -> Result<Void, Error>
}

struct LogoutUseCase: ILogoutUseCase {
    private (set) var loginRepo: LoginRepository
    
    func execute() async -> Result<Void, Error> {
        do {
           try await loginRepo.signOut()
            return .success(())
        } catch(let error) {
            return .failure(error)
        }
    }
}
