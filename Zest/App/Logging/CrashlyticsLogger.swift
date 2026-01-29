//
//  CrashlyticsLogger.swift
//  Zest
//
//  Created by 김민규 on 1/28/26.
//

import FirebaseCrashlytics
import ZestCore

final class CrashlyticsLogger: Logger {

    private let minLevel: LogLevel

    init(minLevel: LogLevel = LogConfig.defaultLogLevel) {
        self.minLevel = minLevel
    }

    func info(_ message: String, trace: TraceContext?) {
        guard minLevel.rawValue <= LogLevel.info.rawValue else { return }
        log("INFO", message, trace: trace)
    }

    func warn(_ message: String, trace: TraceContext?) {
        guard minLevel.rawValue <= LogLevel.warn.rawValue else { return }
        log("WARN", message, trace: trace)
    }

    func error(_ message: String, trace: TraceContext?, error: Error?) {
        guard minLevel.rawValue <= LogLevel.error.rawValue else { return }
        log("ERROR", message, trace: trace)
        if let error = error {
            Crashlytics.crashlytics().record(error: error)
        }
    }

    private func log(_ level: String, _ message: String, trace: TraceContext?) {
        var logMessage = "[\(level)]"
        if let trace = trace {
            logMessage += "[traceId:\(trace.traceId)]"
            if let user = trace.userIdHash {
                logMessage += "[user:\(user)]"
            }
            if let screen = trace.screen {
                logMessage += "[screen:\(screen)]"
            }
        }
        logMessage += " \(message)"
        Crashlytics.crashlytics().log(logMessage)
    }
}
