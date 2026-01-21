//
//  ProductDIContainer.swift
//  Zest
//
//  Created by 김민규 on 1/21/26.
//

import Supabase
import SwiftUI

final class ProductDIContainer {
    private let client = APIService.shared
    
    func makeProductListView() -> some View {
        let repository = ProductRepository(client: client)
        let fetchProductsUseCase = FetchProductsUseCase(repository: repository)
        let viewModel = ProductViewModel(fetchProductsUseCase: fetchProductsUseCase)
        return ProductListView(viewModel: viewModel, productDIContainer: self)
    }
    
    func makeProductDetailView(productId: UUID) -> some View {
        let repository = ProductRepository(client: client)
        let fetchProductDetailUseCase = FetchProductDetailUseCase(repository: repository)
        let viewModel = ProductDetailViewModel(
            productId: productId,
            fetchProductDetailUseCase: fetchProductDetailUseCase
        )
        return ProductDetailView(viewModel: viewModel)
    }
}
