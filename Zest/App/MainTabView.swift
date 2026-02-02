import SwiftUI
import FeatureCoupon

struct MainTabView: View {
    let productDIContainer: ProductDIContainer
    let couponDIContainer: CouponDIContainer
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
            
            couponDIContainer.makeCouponListView()
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
