public enum CouponError: Error, Equatable {
    case network(String)
    case server(String)
    case unknown(String)
    
    var message: String {
        switch self {
        case .network(let msg), .server(let msg), .unknown(let msg):
            return msg
        }
    }
}
