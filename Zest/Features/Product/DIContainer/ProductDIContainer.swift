//
//  ProductDIContainer.swift
//  Zest
//
//  Created by 김민규 on 1/21/26.
//

import Supabase
import SwiftUI
import ZestCore

final class ProductDIContainer {
    private let client = APIService.shared.client
    private let couponDIContainer = CouponDIContainer()
    
    func makeProductListView() -> some View {
        let repository = ProductRepository(client: client)
        let fetchProductsUseCase = FetchProductsUseCase(repository: repository)
        let viewModel = ProductViewModel(fetchProductsUseCase: fetchProductsUseCase)
        return ProductListView(viewModel: viewModel, productDIContainer: self)
    }
    
    func makeProductDetailView(productId: UUID, profileId: UUID?) -> some View {
        let repository = ProductRepository(client: client)
        let fetchProductDetailUseCase = FetchProductDetailUseCase(repository: repository)
        let viewModel = ProductDetailViewModel(
            productId: productId,
            fetchProductDetailUseCase: fetchProductDetailUseCase
        )
        let couponViewModel = couponDIContainer.makeCouponViewModel()
        
        return ProductDetailView(
            viewModel: viewModel,
            couponViewModel: couponViewModel,
            profileId: profileId
        )
    }
}
