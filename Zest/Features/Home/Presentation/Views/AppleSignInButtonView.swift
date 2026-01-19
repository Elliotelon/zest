//
//  AppleSignInButtonView.swift
//  Zest
//
//  Created by 김민규 on 1/19/26.
//

import SwiftUI
import Supabase

struct AppleSignInButtonView: View {
    let supabase = APIService.shared

    var body: some View {
        Button(action: {
            Task {
                await handleAppleLogin()
            }
        }) {
            Text("Sign in with Apple")
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.black)
                .cornerRadius(8)
        }
        .padding()
    }

    // MARK: - Apple 로그인 처리
    func handleAppleLogin() async {
        do {
            
            try await supabase.auth.signInWithOAuth(provider: .apple, redirectTo: URL(string: "Zest://login-callback")!)
            let session = try await supabase.auth.session
            print("현재 세션 있음")
            print("Access token: \(session.accessToken)")
            print("User ID: \(session.user.id)")
            print("Email: \(session.user.email ?? "없음")")
            
        } catch {
            print("Apple 로그인 실패:", error.localizedDescription)
        }
    }
}




