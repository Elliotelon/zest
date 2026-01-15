//
//  HomeViewModel.swift
//  Zest
//
//  Created by 김민규 on 1/15/26.
//

import SwiftUI
import Combine

// 화면의 상태와 로직 관리
@MainActor
class HomeViewModel: ObservableObject {
    @Published var posts: [Post] = []
    
    // 향후 UseCase 및 Coordinator 주입 예정
}
