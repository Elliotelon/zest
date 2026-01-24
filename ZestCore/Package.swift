// swift-tools-version: 6.0
// ↑ 2026년 기준 Swift 6의 강력한 동시성 체크를 위해 6.0 이상 권장

import PackageDescription

let package = Package(
    name: "ZestCore",
    // 1. 플랫폼 설정: SwiftUI 최신 기능(@Observable 등) 및 CI 환경(macOS) 호환성 보장
    platforms: [
        .iOS(.v18),      // 최신 iOS 18 기능 사용 시
        .macOS(.v15)     // GitHub Actions macos-15 러너와 일치시켜 swift test 속도 최적화
    ],
    products: [
        // 2. 앱 타겟(Zest)에서 import ZestCore로 불러올 라이브러리 정의
        .library(
            name: "ZestCore",
            targets: ["ZestCore"]
        ),
    ],
    dependencies: [
        // 외부 라이브러리가 필요하면 여기에 추가 (예: Alamofire, TCA 등)
        .package(url: "https://github.com/supabase/supabase-swift", from: "2.0.0")
    ],
    targets: [
        // 3. 실제 비즈니스 로직 타겟 (Sources/ZestCore)
        .target(
            name: "ZestCore",
            dependencies: [
                .product(name: "Supabase", package: "supabase-swift")
            ],
            swiftSettings: [
                // Swift 6 모드와 데이터 레이스 검증을 활성화하는 표준 설정
                .enableUpcomingFeature("StrictConcurrency"),
                .enableUpcomingFeature("ExistentialAny")
            ]
        ),
        // 4. 유닛 테스트 타겟 (Tests/ZestCoreTests)
        .testTarget(
            name: "ZestCoreTests",
            dependencies: ["ZestCore"] // 소스 타겟의 코드를 테스트하기 위해 의존성 연결
        ),
    ]
)
