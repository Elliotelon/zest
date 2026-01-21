//
//  CartViewModel.swift
//  Zest
//
//  Created by 김민규 on 1/21/26.
//

import SwiftUI
import Combine

@MainActor
final class CartViewModel: ObservableObject {
    @Published var cartItems: [CartItem] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let fetchCartItemsUseCase: FetchCartItemsUseCase
    private let profileId: UUID
    
    init(fetchCartItemsUseCase: FetchCartItemsUseCase, profileId: UUID) {
        self.fetchCartItemsUseCase = fetchCartItemsUseCase
        self.profileId = profileId
    }
    
    func loadCartItems() async {
        isLoading = true
        errorMessage = nil
        
        do {
            cartItems = try await fetchCartItemsUseCase.execute(profileId: profileId)
            print("✅ 장바구니 데이터 로드 성공: \(cartItems.count)개")
        } catch {
            errorMessage = error.localizedDescription
            print("❌ 장바구니 데이터 로드 실패: \(error)")
        }
        
        isLoading = false
    }
}
