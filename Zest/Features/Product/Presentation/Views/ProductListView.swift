//
//  ProductListView.swift
//  Zest
//
//  Created by 김민규 on 1/21/26.
//

import SwiftUI

struct ProductListView: View {
    @StateObject var viewModel: ProductViewModel
    let productDIContainer: ProductDIContainer
    
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
                    List {
                        ForEach(viewModel.products) { product in
                            NavigationLink {
                                productDIContainer.makeProductDetailView(productId: product.id)
                            } label: {
                                ProductRowView(product: product)
                            }
                            .onAppear {
                                // 마지막에서 5번째 아이템이 보이면 다음 페이지 로드 (프리페칭)
                                if viewModel.shouldLoadMore(currentItem: product) {
                                    Task {
                                        await viewModel.loadMoreProducts()
                                    }
                                }
                            }
                        }
                        
                        // 추가 로딩 인디케이터
                        if viewModel.isLoadingMore {
                            HStack {
                                Spacer()
                                ProgressView()
                                    .tint(.blue)            // 로딩 바퀴 색상을 파란색으로 변경
                                    .controlSize(.large)     // 크기를 크게 키움 (small, regular, large)
                                    .padding()
                                Spacer()
                            }
                        }
                    }
                }
            }
            .navigationTitle("상품 목록")
            
        }.task {
            await viewModel.loadProducts()
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
    let diContainer = ProductDIContainer()
    return diContainer.makeProductListView()
}
