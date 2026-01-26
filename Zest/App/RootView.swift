import SwiftUI
import Supabase
import ZestCore

struct RootView: View {
    @StateObject private var coordinator: AppCoordinator
    @StateObject private var sessionManager = SessionManager.shared
    
    private let authDIContainer: AuthDIContainer
    private let productDIContainer: ProductDIContainer
    private let couponDIContainer: CouponDIContainer
    private let authRepository: any AuthRepositoryProtocol // any 키워드 적용
    
    init(
        coordinator: AppCoordinator,
        authDIContainer: AuthDIContainer,
        productDIContainer: ProductDIContainer,
        couponDIContainer: CouponDIContainer,
        authRepository: any AuthRepositoryProtocol
    ) {
        _coordinator = StateObject(wrappedValue: coordinator)
        self.authDIContainer = authDIContainer
        self.productDIContainer = productDIContainer
        self.couponDIContainer = couponDIContainer
        self.authRepository = authRepository
    }
    
    var body: some View {
        Group {
            switch coordinator.currentRoute {
            case .splash:
                ProgressView()
            case .login:
                authDIContainer.makeLoginView()
            case .home:
                MainTabView(
                    productDIContainer: productDIContainer,
                    couponDIContainer: couponDIContainer,
                    profileId: sessionManager.profileId,
                    email: sessionManager.email,
                    name: nil,
                    onLogout: {
                        Task {
                            // ✅ 서버 로그아웃 호출 (SessionManager가 이벤트를 감지함)
                            try? await authRepository.signOut()
                            sessionManager.clearSession()
                        }
                    }
                )
            }
        }
        // ✅ 핵심: 세션 상태가 변하면 즉시 코디네이터 경로 변경 (iOS 17+ 문법)
        .onChange(of: sessionManager.currentSession) { oldSession, newSession in
            if newSession != nil {
                coordinator.showHome()
            } else {
                coordinator.showLogin()
            }
        }
        .task {
            // 1. 저장된 세션 로드
            await sessionManager.loadSession()
            
            // 2. 초기 세션 유무에 따라 화면 즉시 전환
            if sessionManager.currentSession != nil {
                coordinator.showHome()
            } else {
                coordinator.showLogin()
            }
            
            // 3. 코디네이터 시작
            await coordinator.start()
        }
    }
}
