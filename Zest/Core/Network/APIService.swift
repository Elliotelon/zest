//
//  APIService.swift
//  Zest
//
//  Created by 김민규 on 1/15/26.
//

import Foundation
import Supabase

final class APIService {
    
    static let shared = SupabaseClient(
            supabaseURL: Env.supabaseURL,
            supabaseKey: Env.supabaseAnonKey
        )
        
    private init() {}
}
