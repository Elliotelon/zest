//
//  TestHelpers.swift
//  ZestCore
//
//  Created by 김민규 on 1/24/26.
//

import Foundation
import ZestCore

@MainActor
public func setupTestEnvironment() {
    
    APIService.shared.setup(
        url: URL(string: "https://test.supabase.co")!,
        key: "test-anon-key"
    )
}
