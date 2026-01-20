//
//  LoginView.swift
//  Zest
//
//  Created by 김민규 on 1/20/26.
//

import SwiftUI
import AuthenticationServices

struct LoginView: View {
    @StateObject var viewModel: AuthViewModel
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Zest")
                .font(.system(size: 40, weight: .black))
            
            if viewModel.isLoading {
                ProgressView()
                    .controlSize(.large)
            } else {
                SignInWithAppleButton(.signIn) { request in
                    request.requestedScopes = [.fullName, .email]
                } onCompletion: { result in
                    viewModel.handleAppleLoginResult(result: result)
                }
                .signInWithAppleButtonStyle(.black)
                .frame(height: 50)
                .padding(.horizontal, 40)
            }
        }
        .alert("로그인 오류", isPresented: .init(get: { viewModel.errorMessage != nil }, set: { _ in viewModel.errorMessage = nil })) {
            Button("확인", role: .cancel) { }
        } message: {
            Text(viewModel.errorMessage ?? "")
        }
    }
}

#Preview {
    Text("LoginView Preview")
}

