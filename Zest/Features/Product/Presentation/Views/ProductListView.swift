//
//  ProductListView.swift
//  Zest
//
//  Created by 김민규 on 1/21/26.
//

import SwiftUI

struct ProductListView: View {
    @StateObject var viewModel: ProductViewModel
    
    var body: some View {
        NavigationView {
            Group {
                if viewModel.isLoading {
                    ProgressView("상품 로딩 중...")
                } else if let errorMessage = viewModel.errorMessage {
                    VStack {
                        Text("오류 발생")
                            .font(.headline)
                        Text(errorMessage)
                            .font(.caption)
                            .foregroundColor(.red)
                        Button("다시 시도") {
                            Task {
                                await viewModel.loadProducts()
                            }
                        }
                    }
                } else {
                    List(viewModel.products) { product in
                        ProductRowView(product: product)
                    }
                }
            }
            .navigationTitle("상품 목록")
            .task {
                await viewModel.loadProducts()
            }
        }
    }
}

struct ProductRowView: View {
    let product: Product
    
    var body: some View {
        HStack {
            AsyncImage(url: URL(string: product.imageUrl)) { image in
                image
                    .resizable()
                    .scaledToFill()
            } placeholder: {
                Color.gray
            }
            .frame(width: 60, height: 60)
            .cornerRadius(8)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(product.name)
                    .font(.headline)
                Text(product.description)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
            }
            
            Spacer()
            
            Text("₩\(Int(product.price))")
                .font(.subheadline)
                .fontWeight(.bold)
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    let repository = ProductRepository(client: APIService.shared)
    let useCase = FetchProductsUseCase(repository: repository)
    let viewModel = ProductViewModel(fetchProductsUseCase: useCase)
    return ProductListView(viewModel: viewModel)
}
