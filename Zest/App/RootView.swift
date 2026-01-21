import SwiftUI
import Supabase

/// AppCoordinator의 currentRoute에 따라 로그인/홈 화면을 분기하는 루트 뷰
struct RootView: View {
    @StateObject private var coordinator: AppCoordinator
    @StateObject private var sessionManager = SessionManager.shared
    
    private let authDIContainer: AuthDIContainer
    private let productDIContainer: ProductDIContainer
    private let couponDIContainer: CouponDIContainer
    private let authRepository: AuthRepositoryProtocol

    init(
        coordinator: AppCoordinator,
        authDIContainer: AuthDIContainer,
        productDIContainer: ProductDIContainer,
        couponDIContainer: CouponDIContainer,
        authRepository: AuthRepositoryProtocol
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
                    name: nil, // Supabase는 기본적으로 name을 제공하지 않음
                    onLogout: {
                        Task {
                            try? await authRepository.signOut()
                            sessionManager.clearSession()
                        }
                    }
                )
            }
        }
        .task {
            await sessionManager.loadSession()
            await coordinator.start()
        }
    }
}
