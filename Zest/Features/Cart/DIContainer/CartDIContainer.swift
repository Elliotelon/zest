//
//  CartDIContainer.swift
//  Zest
//
//  Created by 김민규 on 1/21/26.
//

import Supabase
import SwiftUI

final class CartDIContainer {
    private let client = APIService.shared
    
    func makeCartView(profileId: UUID) -> some View {
        let repository = CartRepository(client: client)
        let fetchCartItemsUseCase = FetchCartItemsUseCase(repository: repository)
        let viewModel = CartViewModel(fetchCartItemsUseCase: fetchCartItemsUseCase, profileId: profileId)
        return CartView(viewModel: viewModel)
    }
}
