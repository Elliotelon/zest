//
//  MainTabView.swift
//  Zest
//
//  Created by 김민규 on 1/21/26.
//

import SwiftUI

struct MainTabView: View {
    let productDIContainer: ProductDIContainer
    let profileId: UUID?
    let email: String?
    let name: String?
    let onLogout: () -> Void
    
    var body: some View {
        TabView {
            productDIContainer.makeProductListView()
                .tabItem {
                    Label("상품", systemImage: "storefront")
                }
            
            CouponView()
                .tabItem {
                    Label("쿠폰", systemImage: "ticket")
                }
            
            ProfileView(
                profileId: profileId,
                email: email,
                name: name,
                onLogout: onLogout
            )
            .tabItem {
                Label("프로필", systemImage: "person")
            }
        }
    }
}
