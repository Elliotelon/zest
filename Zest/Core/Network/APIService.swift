//
//  APIService.swift
//  Zest
//
//  Created by 김민규 on 1/15/26.
//

import Foundation
import Supabase
import Auth

final class APIService {
    
    static let shared = SupabaseClient(
            supabaseURL: Env.supabaseURL,
            supabaseKey: Env.supabaseAnonKey,
            options: SupabaseClientOptions(
                auth: .init(
                        emitLocalSessionAsInitialSession: true 
                    )
                )
            
        )
        
    private init() {}
}
