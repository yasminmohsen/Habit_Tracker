//
//  LoginWithEmailView.swift
//  HabitTracker
//
//  Created by Yasmin Mohsen on 11/01/2025.
//

import SwiftUI

struct LoginWithEmailView: View {
    //MARK: - States
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var errorMsg: String = ""
    @State private var userAuthorizationState: UserAuthorizationState = .non
    @State private var disabledButton: Bool = true
    @State private var appeared: Double = 0.0
    @State private var showLoader: Bool = false
    
    //MARK: - StateObject
    @StateObject private var viewModel = LoginWithEmailViewModel(signUpWithEmailUseCase: SignUpWithEmailUseCase(loginRepo: LoginDataRepository()), loginWithEmailUseCase: LoginWithEmailUseCase(loginRepo: LoginDataRepository()))
    
    //MARK: - Bindings
    @Binding var path: [String]
    
    //MARK: - View
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                Spacer()
                Image("HabitImage")
                    .resizable()
                    .aspectRatio(contentMode: /*@START_MENU_TOKEN@*/.fill/*@END_MENU_TOKEN@*/)
                    .frame(width: UIScreen.main.bounds.width, height: 100)
                   // .padding(.top, 200)
                Spacer()
                ///Email textField
                TextField("Email", text: $email)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(Color.black)
                    .padding(.all)
                    .textContentType(.emailAddress)
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
                    .textFieldStyle(.plain)
                    .overlay {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(.clear)
                            .stroke(email.isEmpty ? .gray.opacity(0.5):.black, lineWidth: 2)
                            .frame(height: 50)
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom,16)
                ///Password textField
                SecureField("Password", text: $password)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(Color.black)
                    .padding(.all)
                    .textContentType(.password)
                    .textFieldStyle(.plain)
                    .overlay {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(.clear)
                            .stroke(password.isEmpty ? .gray.opacity(0.5):.black, lineWidth: 2)
                            .frame(height: 50)
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 10)
                ///Error message
                Text("\(errorMsg)")
                    .font(.system(size: 12, weight:.bold))
                    .foregroundStyle(.red)
                    .multilineTextAlignment(.leading)
                    .frame(alignment: .leading)
                    .padding(.horizontal, 16)
                    .padding(.bottom, 16)
                ///Login button
                Button {
                    showLoader = true
                    Task {
                        await viewModel.loginWithEmail(email: email, password: password, userAuthorizationState: userAuthorizationState)
                    }
                } label: {
                    Text(userAuthorizationState == .signedUp ? "Sign Up" : "Login")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundStyle(showLoader ? Color.clear : Color("WhiteColor"))
                        .padding(.all, 16)
                        .frame(maxWidth: .infinity)
                        .background {
                            RoundedRectangle(cornerRadius: 24)
                                .fill(Color("CustomGreen"))
                                .frame(height: 50)
                        }.overlay(content: {
                            if showLoader{
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle())
                            }
                        })
                        .padding(.horizontal, 24)
                        .padding(.bottom, 16)
                }.buttonStyle(.plain)
                    .disabled(disabledButton)
                HStack {
                    Text( userAuthorizationState == .signedUp ? "Already have an account?" : "Don't have an account?")
                    Button(userAuthorizationState == .signedUp ? "Login" : "Register") {
                        userAuthorizationState =  userAuthorizationState != .signedUp ? .signedUp : .loggedIn
                        errorMsg = ""
                        email = ""
                        password = ""
                    }
                }
            }.padding(.bottom, 24)
        }.navigationBarBackButtonHidden()
            .opacity(appeared)
            .animation(Animation.easeInOut(duration: 2.0), value: appeared)
        ///Lifecycle methods
            .onAppear {self.appeared = 1.0}
            .onDisappear {self.appeared = 0.0}
        ///Change observers
            .onChange(of: email) { _,_ in
                disabledButton = !checkEmail(email: email)
            }.onReceive(viewModel.$requestState) {
                switch $0 {
                case .success:
                    showLoader = false
                    path.append("homeView") // navigate to Home view
                case .failure(msg: let msg):
                    showLoader = false
                    errorMsg = msg
                default:
                    break
                }
            }
    }
    
    private func checkEmail(email: String) -> Bool {
        let emailRegex = "^[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]{2,}$"
        let emailPredicate = NSPredicate(format: "SELF MATCHES[c] %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
}

#Preview {
    LoginWithEmailView(path: Binding.constant([]))
}
