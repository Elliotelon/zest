//
//  CartView.swift
//  Zest
//
//  Created by 김민규 on 1/21/26.
//

import SwiftUI

struct CartView: View {
    @StateObject var viewModel: CartViewModel
    
    var body: some View {
        NavigationView {
            Group {
                if viewModel.isLoading {
                    ProgressView("장바구니 로딩 중...")
                } else if let errorMessage = viewModel.errorMessage {
                    VStack {
                        Text("오류 발생")
                            .font(.headline)
                        Text(errorMessage)
                            .font(.caption)
                            .foregroundColor(.red)
                        Button("다시 시도") {
                            Task {
                                await viewModel.loadCartItems()
                            }
                        }
                    }
                } else if viewModel.cartItems.isEmpty {
                    VStack {
                        Image(systemName: "cart")
                            .font(.system(size: 60))
                            .foregroundColor(.gray)
                        Text("장바구니가 비어있습니다")
                            .font(.headline)
                            .padding()
                    }
                } else {
                    List(viewModel.cartItems) { item in
                        CartItemRowView(item: item)
                    }
                }
            }
            .navigationTitle("장바구니")
            .task {
                await viewModel.loadCartItems()
            }
        }
    }
}

struct CartItemRowView: View {
    let item: CartItem
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("상품 ID: \(item.productId.uuidString)")
                    .font(.caption)
                Text("수량: \(item.quantity)")
                    .font(.caption)
            }
            Spacer()
        }
        .padding(.vertical, 4)
    }
}
