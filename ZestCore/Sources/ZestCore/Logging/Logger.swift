//
//  Logger.swift
//  Zest
//
//  Created by 김민규 on 1/28/26.
//

public protocol Logger {
    func info(_ message: String, trace: TraceContext?)
    func warn(_ message: String, trace: TraceContext?)
    func error(_ message: String, trace: TraceContext?, error: Error?)
}
