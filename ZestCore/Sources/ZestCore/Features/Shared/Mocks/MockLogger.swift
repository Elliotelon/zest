public final class MockLogger: Logger {
    var logs: [String]
    
    public init(logs: [String]=[]) {
        self.logs = logs
    }
    
    public func info(_ message: String, trace: TraceContext?) {
        logs.append("[INFO] \(message)")
    }
    
    public func warn(_ message: String, trace: TraceContext?) {
        logs.append("[WARN] \(message)")
    }
    
    public func error(_ message: String, trace: TraceContext?, error: Error?) {
        logs.append("[ERROR] \(message)")
    }
}
