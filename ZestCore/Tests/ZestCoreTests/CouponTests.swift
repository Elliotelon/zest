//
//  CouponTests.swift
//  ZestCore
//
//  Created by 김민규 on 1/24/26.
//

import Testing
@testable import ZestCore

@Suite("쿠폰 테스트.")
@MainActor
struct CouponTests {
    
    init() {
        setupTestEnvironment()
    }

    @Test("쿠폰 목록 로드 성공 확인.")
    func testLoadCoupons() async throws {
        
    }
}
