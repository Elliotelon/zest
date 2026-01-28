//
//  LoggingConfig.swift
//  Zest
//
//  Created by 김민규 on 1/28/26.
//

import ZestCore

public struct LogConfig {
    public static var defaultLogLevel: LogLevel {
        #if DEBUG
        return .info
        #else
        return .warn
        #endif
    }
}


