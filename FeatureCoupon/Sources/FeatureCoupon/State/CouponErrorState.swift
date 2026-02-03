public enum CouponErrorState {
    case network
    case server
    case unauthorized
    case domain(message: String)
}
