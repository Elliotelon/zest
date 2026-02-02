// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "FeatureCoupon",
    platforms: [
        .iOS(.v18),      // 최신 iOS 18 기능 사용 시
        .macOS(.v15)     // GitHub Actions macos-15 러너와 일치시켜 swift test 속도 최적화
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "FeatureCoupon",
            targets: ["FeatureCoupon"]
        ),
    ],
    dependencies: [
        // 외부 라이브러리가 필요하면 여기에 추가 (예: Alamofire, TCA 등)
        .package(url: "https://github.com/supabase/supabase-swift", from: "2.0.0"),
        .package(path: "../ZestCore")
        
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "FeatureCoupon",
            dependencies: [
                .product(name: "Supabase", package: "supabase-swift"),
                .product(name: "ZestCore", package: "ZestCore")
            ],
            swiftSettings: [
                // Swift 6 모드와 데이터 레이스 검증을 활성화하는 표준 설정
                .enableUpcomingFeature("StrictConcurrency"),
                .enableUpcomingFeature("ExistentialAny")
            ]
        ),
        .testTarget(
            name: "FeatureCouponTests",
            dependencies: ["FeatureCoupon"]
        ),
    ]
)
