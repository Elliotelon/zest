public protocol Logger {
    func info(_ message: String, trace: TraceContext?)
    func warn(_ message: String, trace: TraceContext?)
    func error(_ message: String, trace: TraceContext?, error: Error?)
}
