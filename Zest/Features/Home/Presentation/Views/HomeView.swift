//
//  ContentView.swift
//  Zest
//
//  Created by 김민규 on 1/13/26.
//

import SwiftUI

struct HomeView: View {
    @StateObject var viewModel: HomeViewModel = HomeViewModel(useCase: FetchPostsUseCase(repository: PostRepository()))
    var body: some View {
        List(viewModel.posts) { post in
            Text(post.title)
        }
        .task { await viewModel.load() } 
    }
}


#Preview {
    HomeView()
}
