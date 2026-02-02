import SwiftUI
import ZestCore
import FeatureCoupon

@MainActor
final class AppDIContainer {
    private let client = APIService.shared.client
    private let logger: any Logger

    init() {
        #if DEBUG
        logger = DebugLogger()
        #else
        logger = CrashlyticsLogger(minLevel: .warn)
        #endif
        
//        logger = CrashlyticsLogger(minLevel: .info)
    }
    
    private lazy var authRepository: AuthRepositoryProtocol = {
        AuthRepository(client: client)
    }()
    
    private lazy var checkSessionUseCase: CheckSessionUseCase = {
        CheckSessionUseCase(repository: authRepository)
    }()
    
    private lazy var appCoordinator: AppCoordinator = {
        AppCoordinator(
            
        )
    }()
    
    private lazy var authDIContainer: AuthDIContainer = {
        AuthDIContainer(repository: authRepository)
    }()
    
    private lazy var couponDIContainer: CouponDIContainer = {
        CouponDIContainer(logger: logger)
    }()

    private lazy var productDIContainer: ProductDIContainer = {
        ProductDIContainer(couponDIContainer: couponDIContainer)
    }()

    
    func makeRootView() -> some View {
        RootView(
            coordinator: appCoordinator,
            authDIContainer: authDIContainer,
            productDIContainer: productDIContainer,
            couponDIContainer: couponDIContainer,
            authRepository: authRepository
        )
    }
}

