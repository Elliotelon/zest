//
//  HomeViewModel.swift
//  Zest
//
//  Created by 김민규 on 1/15/26.
//

import SwiftUI
import Combine

@MainActor
class HomeViewModel: ObservableObject {
    @Published var posts: [Post] = []
    private let useCase: FetchPostsUseCase

    init(useCase: FetchPostsUseCase) {
        self.useCase = useCase
    }

    func load() async {
        do {
            self.posts = try await useCase.execute()
            print("✅ 데이터 로드 성공: \(posts.count)개")
        } catch {
            print(String(describing: error))
        }
    }
}
