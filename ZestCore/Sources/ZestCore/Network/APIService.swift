//
//  APIService.swift
//  Zest
//
//  Created by 김민규 on 1/15/26.
//

import Foundation
import Supabase

@MainActor
public final class APIService {
    
    public static let shared = APIService()
       
       // 1. 내부적으로는 옵셔널로 보관
       private var _client: SupabaseClient?

       // 2. 외부에서는 이 프로퍼티를 통해 접근 (연산 프로퍼티)
       public var client: SupabaseClient {
           guard let client = _client else {
               fatalError("❌ [ZestCore] APIService.shared.setup()이 호출되지 않았습니다. ZestApp의 init에서 먼저 초기화하세요.")
           }
           return client
       }

       private init() {}

       public func setup(url: URL, key: String) {
           self._client = SupabaseClient(supabaseURL: url, supabaseKey: key)
       }
}
