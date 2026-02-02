public struct TraceContext {
    public let traceId: String
    public let userIdHash: String?
    public let screen: String?
    
    public init(traceId: String, userIdHash: String? = nil, screen: String? = nil) {
        self.traceId = traceId
        self.userIdHash = userIdHash
        self.screen = screen
    }
}

