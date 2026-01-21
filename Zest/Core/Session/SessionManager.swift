//
//  SessionManager.swift
//  Zest
//
//  Created by AI Assistant on 1/21/26.
//

import Foundation
import Supabase
import Combine

/// 전역 세션 관리자
/// 앱 전체에서 현재 로그인된 사용자의 세션 정보를 관리합니다.
@MainActor
final class SessionManager: ObservableObject {
    static let shared = SessionManager()
    
    @Published private(set) var currentSession: Session?
    @Published private(set) var isLoading = false
    
    private let client: SupabaseClient
    
    private init() {
        self.client = APIService.shared
    }
    
    /// 현재 세션 정보를 가져옵니다.
    var profileId: UUID? {
        currentSession?.user.id
    }
    
    var email: String? {
        currentSession?.user.email
    }
    
    /// 세션을 로드합니다.
    func loadSession() async {
        guard !isLoading else { return }
        
        isLoading = true
        defer { isLoading = false }
        
        do {
            currentSession = try await client.auth.session
            print("✅ 세션 로드 성공: \(profileId?.uuidString ?? "없음")")
        } catch {
            currentSession = nil
            print("⚠️ 세션 로드 실패 (로그아웃 상태일 수 있음): \(error.localizedDescription)")
        }
    }
    
    /// 세션을 새로고침합니다.
    func refreshSession() async {
        await loadSession()
    }
    
    /// 세션을 초기화합니다. (로그아웃 시 호출)
    func clearSession() {
        currentSession = nil
    }
}
