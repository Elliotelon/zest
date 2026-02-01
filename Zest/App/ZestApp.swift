import SwiftUI
import ZestCore
import Firebase

@main
struct ZestApp: App {
    
    @State private var appDIContainer: AppDIContainer?
//    private let logger = CrashlyticsLogger(minLevel: .info)
    
    init() {
        APIService.shared.setup(
            url: Env.supabaseURL,
            key: Env.supabaseAnonKey
        )
        
        FirebaseApp.configure()
        print(Env.googleAppID)
        // Debug 빌드에서도 Crashlytics 로그 보내기
        Crashlytics.crashlytics().setCrashlyticsCollectionEnabled(true)
               
        Crashlytics.crashlytics().log("Firebase 초기화 완료")
    }
    
    var body: some Scene {
        WindowGroup {
            
//            ContentView(logger: logger)
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
