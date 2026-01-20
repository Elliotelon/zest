//
//  AuthViewModel.swift
//  Zest
//
//  Created by 김민규 on 1/20/26.
//

import SwiftUI
import Combine
import AuthenticationServices

@MainActor
final class AuthViewModel: ObservableObject {
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let appleLoginUseCase: AppleLoginUseCase
    
    init(appleLoginUseCase: AppleLoginUseCase) {
        self.appleLoginUseCase = appleLoginUseCase
    }
    
    func handleAppleLoginResult(result: Result<ASAuthorization, Error>) {
        switch result {
        case .success(let authorization):
            guard let credential = authorization.credential as? ASAuthorizationAppleIDCredential else { return }
            
            isLoading = true
            Task {
                do {
                    try await appleLoginUseCase.execute(with: credential)
                    print("Zest 로그인 성공")
                } catch {
                    self.errorMessage = error.localizedDescription
                }
                isLoading = false
            }
            
        case .failure(let error):
            let authError = error as NSError
            if authError.domain == ASAuthorizationErrorDomain && authError.code == ASAuthorizationError.canceled.rawValue {
                return
            }
            self.errorMessage = error.localizedDescription
        }
    }
}

