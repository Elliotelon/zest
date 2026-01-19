//
//  ContentView.swift
//  Zest
//
//  Created by 김민규 on 1/13/26.
//

import SwiftUI
import AuthenticationServices

struct HomeView: View {
    @StateObject var viewModel: HomeViewModel
    
    var body: some View {
        List(viewModel.posts) { post in
            Text(post.title)
        }
        .task { await viewModel.load() }
        
        VStack(spacing: 20) {
            Text("Zest")
                .font(.system(size: 40, weight: .black))
            
            if viewModel.isLoading {
                ProgressView()
                    .controlSize(.large)
            } else {
                // [수정] 버튼 자체가 팝업을 관리하므로 중복 호출이 발생하지 않음
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
    //    HomeView()
}
