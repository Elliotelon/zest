//
//  ZestApp.swift
//  Zest
//
//  Created by 김민규 on 1/13/26.
//

import SwiftUI
import ZestCore

@main
struct ZestApp: App {
    
    @State private var appDIContainer: AppDIContainer?
    
    init() {
        APIService.shared.setup(
            url: Env.supabaseURL,
            key: Env.supabaseAnonKey
        )
    }
    
    var body: some Scene {
        WindowGroup {
            if let container = appDIContainer {
                container.makeRootView()
            } else {
                Color.clear
                    .onAppear {
                        // 4. 최초 등장 시점에 컨테이너를 생성하여 nil 크래시를 방지합니다.
                        appDIContainer = AppDIContainer()
                    }
            }
        }
    }
}
