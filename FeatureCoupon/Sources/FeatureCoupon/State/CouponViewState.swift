public enum CouponViewState {
    case idle
    case loading
    case content(
        availableCoupons: [Coupon],
        userCoupons: [UserCoupon]
    )
    case empty
    case error(CouponErrorState)
}
