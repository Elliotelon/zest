import SwiftUI
import ZestCore

struct ContentView: View {

    let logger: CrashlyticsLogger

    var body: some View {
        VStack(spacing: 20) {

            Button("Info 로그 보내기") {
                let trace = TraceContext(traceId: UUID().uuidString, screen: "HomeView")
                print("ffffvv")
                logger.info("🔹 Info 로그 테스트", trace: trace)
            }
            .buttonStyle(.borderedProminent)

            Button("Warn 로그 보내기") {
                let trace = TraceContext(traceId: UUID().uuidString, screen: "HomeView")
                logger.warn("⚠️ Warn 로그 테스트", trace: trace)
            }
            .buttonStyle(.borderedProminent)

            Button("Error 로그 보내기") {
                let trace = TraceContext(traceId: UUID().uuidString, screen: "HomeView")
                let sampleError = NSError(domain: "com.example.MyApp", code: 500, userInfo: [NSLocalizedDescriptionKey: "테스트 에러"])
                logger.error("❌ Error 로그 테스트", trace: trace, error: sampleError)
            }
            .buttonStyle(.borderedProminent)

            Button("강제 크래시") {
                fatalError("테스트 크래시")
            }
            .buttonStyle(.borderedProminent)
            .tint(.red)

        }
        .padding()
    }
}

