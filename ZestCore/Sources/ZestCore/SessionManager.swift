import Foundation
import Supabase
import Combine

@MainActor
public final class SessionManager: ObservableObject {
    public static let shared = SessionManager()
    
    @Published public private(set) var currentSession: Session?
    @Published public private(set) var isLoading = false
    
    private let client: SupabaseClient
    private var authTask: Task<Void, Never>?

    private init() {
        self.client = APIService.shared.client
        // ✅ 생성 시점에 실시간 감지 시작
        observeAuthChanges()
    }
    
    public var profileId: UUID? { currentSession?.user.id }
    public var email: String? { currentSession?.user.email }
    
    /// ✅ Supabase 인증 상태 실시간 구독
    public func observeAuthChanges() {
        authTask?.cancel()
        authTask = Task {
            // authStateChanges는 로그인/로그아웃/토큰갱신 이벤트를 실시간으로 방출합니다.
            for await (event, session) in client.auth.authStateChanges {
                print("🚀 [SessionManager] Auth Event: \(event)")
                self.currentSession = session
                
                if event == .signedOut {
                    self.currentSession = nil
                }
            }
        }
    }
    
    /// 초기 세션 로드 (App 진입 시 호출)
    public func loadSession() async {
        guard !isLoading else { return }
        isLoading = true
        defer { isLoading = false }
        
        do {
            // emitLocalSessionAsInitialSession 옵션에 의해 로컬 세션을 즉시 가져옵니다.
            currentSession = try await client.auth.session
        } catch {
            currentSession = nil
        }
    }

    public func clearSession() {
        currentSession = nil
    }
}
