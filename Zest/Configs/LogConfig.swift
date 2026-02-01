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


