public struct CouponScreenState {
    //    var availableCoupons: [Coupon] = []
    //    var userCoupons: [UserCoupon] = []
    public var isLoading: Bool = false
    public var isIssuing: Bool = false
    //    var error: CouponError? = nil
    public var errorMessage: String? = nil
    public var successMessage: String? = nil
    
    public init(isLoading: Bool=false, isIssuing: Bool=false, errorMessage: String? = nil, successMessage: String? = nil) {
        self.isLoading = isLoading
        self.isIssuing = isIssuing
        self.errorMessage = errorMessage
        self.successMessage = successMessage
    }
    
}
