import Foundation
import Supabase

@MainActor
public final class APIService {
    
    public static let shared = APIService()
    
    private var _client: SupabaseClient?
    
    public var client: SupabaseClient {
        guard let client = _client else {
            fatalError("❌ [ZestCore] APIService.shared.setup()이 호출되지 않았습니다. ZestApp의 init에서 먼저 초기화하세요.")
        }
        return client
    }
    
    private init() {}
    
    public func setup(url: URL, key: String) {
        
        let authOptions = SupabaseClientOptions.AuthOptions(
            emitLocalSessionAsInitialSession: true
        )
        
        let options = SupabaseClientOptions(
            auth: authOptions
        )
        
        self._client = SupabaseClient(
            supabaseURL: url,
            supabaseKey: key,
            options: options
        )
    }
}
