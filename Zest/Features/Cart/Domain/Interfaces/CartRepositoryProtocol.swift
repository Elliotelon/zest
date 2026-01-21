//
//  CartRepositoryProtocol.swift
//  Zest
//
//  Created by 김민규 on 1/21/26.
//

import Foundation

protocol CartRepositoryProtocol {
    /// 사용자의 장바구니 목록을 가져옵니다.
    func fetchCartItems(profileId: UUID) async throws -> [CartItem]
    
    /// 장바구니에 상품을 추가합니다.
    func addToCart(profileId: UUID, productId: UUID, quantity: Int) async throws
    
    /// 장바구니 아이템의 수량을 업데이트합니다.
    func updateCartItem(id: UUID, quantity: Int) async throws
    
    /// 장바구니에서 아이템을 삭제합니다.
    func removeFromCart(id: UUID) async throws
}
