import Foundation
import Supabase

public final class CouponRepository: CouponRepositoryProtocol {
    private let client: SupabaseClient
    
    public init(client: SupabaseClient) {
        self.client = client
    }
    
    public func fetchAvailableCoupons() async throws -> [Coupon] {
        let response: [CouponDTO] = try await client
            .from("coupons")
            .select()
            .eq("is_active", value: true)
            .order("created_at", ascending: false)
            .execute()
            .value
        
        return response.map { $0.toEntity() }
    }
    
    public func fetchCoupon(id: UUID) async throws -> Coupon {
        let response: CouponDTO = try await client
            .from("coupons")
            .select()
            .eq("id", value: id.uuidString)
            .single()
            .execute()
            .value
        
        return response.toEntity()
    }
    
    public func issueCoupon(profileId: UUID, couponId: UUID) async throws -> (success: Bool, message: String) {
        // Supabase RPC 함수 호출 (동시성 제어가 적용된 함수)
        let response: IssueCouponResponseDTO = try await client
            .rpc("issue_coupon", params: [
                "p_profile_id": profileId.uuidString,
                "p_coupon_id": couponId.uuidString
            ])
            .execute()
            .value
        
        if response.success {
            let message = response.coupon.map {
                "쿠폰 발급 성공! (\($0.issuedCount)/\($0.maxCount))"
            } ?? "쿠폰이 발급되었습니다."
            return (true, message)
        } else {
            let message: String
            switch response.error {
            case "COUPON_NOT_FOUND":
                message = "쿠폰을 찾을 수 없습니다."
            case "COUPON_INACTIVE":
                message = "이 쿠폰은 현재 사용할 수 없습니다."
            case "COUPON_EXHAUSTED":
                message = "쿠폰이 모두 소진되었습니다. 😢"
            case "ALREADY_ISSUED":
                message = "이미 발급받은 쿠폰입니다."
            default:
                message = response.message ?? "쿠폰 발급에 실패했습니다."
            }
            return (false, message)
        }
    }
    
    public func fetchUserCoupons(profileId: UUID) async throws -> [UserCoupon] {
        let response: [UserCouponDTO] = try await client
            .from("profiles_coupons")
            .select()
            .eq("profile_id", value: profileId.uuidString)
            .order("issued_at", ascending: false)
            .execute()
            .value
        
        return response.map { $0.toEntity() }
    }
    
    public func useCoupon(userCouponId: UUID, productId: UUID) async throws {
        try await client
            .from("profiles_coupons")
            .update([
                "used_at": Date().ISO8601Format(),
                "product_id": productId.uuidString
            ])
            .eq("id", value: userCouponId.uuidString)
            .execute()
    }
}
