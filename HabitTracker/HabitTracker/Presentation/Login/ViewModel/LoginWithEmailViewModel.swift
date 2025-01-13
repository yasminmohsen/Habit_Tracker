//
//  LoginWithEmailViewModel.swift
//  HabitTracker
//
//  Created by Yasmin Mohsen on 11/01/2025.
//

import Foundation

final class LoginWithEmailViewModel: ObservableObject {
    //MARK: - Use cases :
    private let signUpWithEmailUseCase: ISignUpWithEmailUseCase
    private let loginWithEmailUseCase: ILoginWithEmailUseCase
    
    //MARK: - Publishers
    @Published var requestState: RequestState = .non

    //MARK: - Initializer
    init(signUpWithEmailUseCase: ISignUpWithEmailUseCase, loginWithEmailUseCase: ILoginWithEmailUseCase) {
        self.signUpWithEmailUseCase = signUpWithEmailUseCase
        self.loginWithEmailUseCase = loginWithEmailUseCase
    }
    
    //MARK: - Helpers
    func loginWithEmail(email: String, password: String, userAuthorizationState: UserAuthorizationState) async {
        requestState = .loading
        
        let result = userAuthorizationState == .signedUp ? await signUpWithEmailUseCase.execute(email: email, password: password) : await loginWithEmailUseCase.execute(email: email, password: password)
       
        switch result {
        case .success(let _):
           self.requestState = .success
        case .failure(let error):
         self.requestState = .failure(msg: error.localizedDescription)
        }
    }
}
