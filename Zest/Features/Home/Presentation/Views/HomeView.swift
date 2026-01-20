//
//  ContentView.swift
//  Zest
//
//  Created by 김민규 on 1/13/26.
//

import SwiftUI

struct HomeView: View {
    @StateObject var viewModel: HomeViewModel
    
    var body: some View {
        NavigationView {
            List(viewModel.posts) { post in
                Text(post.title)
            }
            .navigationTitle("Zest")
            .task { await viewModel.load() }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("로그아웃") {
                        Task {
                            await viewModel.logout()
                        }
                    }
                }
            }
        }
    }
}


#Preview {
    //    HomeView()
}
