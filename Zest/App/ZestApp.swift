//
//  ZestApp.swift
//  Zest
//
//  Created by 김민규 on 1/13/26.
//

import SwiftUI

@main
struct ZestApp: App {
    
    private let homeDIContainer = HomeDIContainer()
   
    var body: some Scene {
        WindowGroup {
            homeDIContainer.makeHomeView()
        }
    }
}
