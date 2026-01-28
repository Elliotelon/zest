//
//  DebugLogger.swift
//  Zest
//
//  Created by 김민규 on 1/28/26.
//
import ZestCore
import Foundation

final class DebugLogger: Logger {
    func info(_ message: String, trace: TraceContext?) {
        print("[INFO][\(trace?.traceId ?? "")] \(message)")
    }

    func warn(_ message: String, trace: TraceContext?) {
        print("[WARN][\(trace?.traceId ?? "")] \(message)")
    }

    func error(_ message: String, trace: TraceContext?, error: Error?) {
        print("[ERROR][\(trace?.traceId ?? "")] \(message) \(error?.localizedDescription ?? "")")
    }
}
