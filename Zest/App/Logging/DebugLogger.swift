import ZestCore
import Foundation
import os

final class DebugLogger: ZestCore.Logger {
    private let logger = os.Logger(subsystem: Bundle.main.bundleIdentifier ?? "App", category: "UseCase")

    func info(_ message: String, trace: TraceContext?) {
        let traceId = trace?.traceId ?? ""
        logger.info("[INFO][\(traceId)] \(message, privacy: .public)")
    }

    func warn(_ message: String, trace: TraceContext?) {
        let traceId = trace?.traceId ?? ""
        logger.warning("[WARN][\(traceId)] \(message, privacy: .public)")
    }

    func error(_ message: String, trace: TraceContext?, error: Error?) {
        let traceId = trace?.traceId ?? ""
        let errorMsg = error?.localizedDescription ?? ""
        logger.error("[ERROR][\(traceId)] \(message) \(errorMsg, privacy: .public)")
    }
}
