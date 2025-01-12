//
//  LoginWithEmailViewModel.swift
//  HabitTracker
//
//  Created by Yasmin Mohsen on 11/01/2025.
//

import Foundation

final class LoginWithEmailViewModel: ObservableObject {
    
    @Published var requestState: RequestState = .non
    
    private let signUpWithEmailUseCase: ISignUpWithEmailUseCase
    private let loginWithEmailUseCase: ILoginWithEmailUseCase
    
    init(signUpWithEmailUseCase: ISignUpWithEmailUseCase, loginWithEmailUseCase: ILoginWithEmailUseCase) {
        self.signUpWithEmailUseCase = signUpWithEmailUseCase
        self.loginWithEmailUseCase = loginWithEmailUseCase
    }
    
    func loginWithEmail(email: String, password: String, userAuthorizationState: UserAuthorizationState) async {
        await MainActor.run {
            requestState = .loading
        }
        let result = userAuthorizationState == .signedUp ? await signUpWithEmailUseCase.execute(email: email, password: password) : await loginWithEmailUseCase.execute(email: email, password: password)
        switch result {
        case .success(let _):
            await MainActor.run { self.requestState = .success }
        case .failure(let error):
            await MainActor.run { self.requestState = .failure(msg: error.localizedDescription) }
        }
    }
}
