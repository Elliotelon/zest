import SwiftUI
import Combine
import ZestCore

/// 앱의 현재 경로(Route) 상태만 관리
@MainActor
public final class AppCoordinator: ObservableObject {
    @Published var currentRoute: AppRoute = .splash
    
    
    /// 초기 시작 로직 (필요 시 최소한의 초기화만 수행)
    func start() async {
        // 이제 초기 세션 체크는 SessionManager가 담당하므로
        // 여기서는 부가적인 앱 초기화 로직만 남깁니다.
    }
    
    // ✅ 뷰에서 직접 호출하거나 RootView의 onChange에서 호출할 경로 변경 메서드
    func showHome() {
        currentRoute = .home
    }
    
    func showLogin() {
        currentRoute = .login
    }
}



