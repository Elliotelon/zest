//
//  ProductDetailView.swift
//  Zest
//
//  Created by AI Assistant on 1/21/26.
//

import SwiftUI

struct ProductDetailView: View {
    @StateObject var viewModel: ProductDetailViewModel
    
    var body: some View {
        ScrollView {
            if viewModel.isLoading {
                ProgressView("상품 정보 로딩 중...")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding(.top, 100)
            } else if let errorMessage = viewModel.errorMessage {
                VStack(spacing: 16) {
                    Image(systemName: "exclamationmark.triangle")
                        .font(.system(size: 50))
                        .foregroundColor(.orange)
                    Text("오류 발생")
                        .font(.headline)
                    Text(errorMessage)
                        .font(.caption)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                    Button("다시 시도") {
                        Task {
                            await viewModel.loadProductDetail()
                        }
                    }
                    .buttonStyle(.borderedProminent)
                }
                .padding()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding(.top, 100)
            } else if let product = viewModel.product {
                VStack(alignment: .leading, spacing: 0) {
                    // 상품 이미지
                    AsyncImage(url: URL(string: product.imageUrl)) { image in
                        image
                            .resizable()
                            .scaledToFill()
                    } placeholder: {
                        Rectangle()
                            .fill(Color.gray.opacity(0.3))
                            .overlay(
                                ProgressView()
                            )
                    }
                    .frame(height: 300)
                    .clipped()
                    
                    VStack(alignment: .leading, spacing: 16) {
                        // 상품명
                        Text(product.name)
                            .font(.title2)
                            .fontWeight(.bold)
                            .padding(.top, 20)
                        
                        // 가격 정보
                        VStack(alignment: .leading, spacing: 8) {
                            if viewModel.isCouponApplied {
                                HStack {
                                    Text("원가")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                    Text("₩\(Int(product.price))")
                                        .font(.body)
                                        .foregroundColor(.secondary)
                                        .strikethrough()
                                }
                                
                                HStack {
                                    Text("할인가")
                                        .font(.subheadline)
                                        .fontWeight(.semibold)
                                    Text("₩\(Int(viewModel.finalPrice))")
                                        .font(.title)
                                        .fontWeight(.bold)
                                        .foregroundColor(.red)
                                }
                                
                                Text("-₩\(Int(viewModel.discountAmount)) 할인")
                                    .font(.caption)
                                    .foregroundColor(.red)
                            } else {
                                Text("₩\(Int(product.price))")
                                    .font(.title)
                                    .fontWeight(.bold)
                            }
                        }
                        .padding(.vertical, 8)
                        
                        Divider()
                        
                        // 상품 설명
                        VStack(alignment: .leading, spacing: 8) {
                            Text("상품 설명")
                                .font(.headline)
                            Text(product.description)
                                .font(.body)
                                .foregroundColor(.secondary)
                        }
                        .padding(.vertical, 8)
                        
                        Divider()
                        
                        // 쿠폰 섹션
                        VStack(alignment: .leading, spacing: 12) {
                            Text("쿠폰")
                                .font(.headline)
                            
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    HStack {
                                        Image(systemName: "ticket.fill")
                                            .foregroundColor(.orange)
                                        Text("10% 할인 쿠폰")
                                            .font(.subheadline)
                                            .fontWeight(.semibold)
                                    }
                                    Text("첫 구매 고객 특별 할인")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                                
                                Spacer()
                                
                                Button(action: {
                                    if viewModel.isCouponApplied {
                                        viewModel.removeCoupon()
                                    } else {
                                        viewModel.applyCoupon()
                                    }
                                }) {
                                    Text(viewModel.isCouponApplied ? "적용됨" : "적용하기")
                                        .font(.caption)
                                        .fontWeight(.semibold)
                                        .foregroundColor(.white)
                                        .padding(.horizontal, 16)
                                        .padding(.vertical, 8)
                                        .background(viewModel.isCouponApplied ? Color.green : Color.orange)
                                        .cornerRadius(8)
                                }
                            }
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.orange.opacity(0.1))
                            )
                        }
                        .padding(.vertical, 8)
                        
                        Spacer(minLength: 100)
                    }
                    .padding(.horizontal, 20)
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.loadProductDetail()
        }
    }
}

#Preview {
    let repository = ProductRepository(client: APIService.shared)
    let useCase = FetchProductDetailUseCase(repository: repository)
    let viewModel = ProductDetailViewModel(
        productId: UUID(),
        fetchProductDetailUseCase: useCase
    )
    return NavigationView {
        ProductDetailView(viewModel: viewModel)
    }
}
