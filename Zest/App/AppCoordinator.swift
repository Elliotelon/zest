import SwiftUI
import Combine
import ZestCore

@MainActor
public final class AppCoordinator: ObservableObject {
    @Published var currentRoute: AppRoute = .splash
    
    // ✅ 뷰에서 직접 호출하거나 RootView의 onChange에서 호출할 경로 변경 메서드
    func showHome() {
        currentRoute = .home
    }
    
    func showLogin() {
        currentRoute = .login
    }
}
