//
//  ProductRepository.swift
//  Zest
//
//  Created by 김민규 on 1/21/26.
//

import Foundation
import Supabase

final class ProductRepository: ProductRepositoryProtocol {
    private let client: SupabaseClient
    
    init(client: SupabaseClient) {
        self.client = client
    }
    
    func fetchProducts() async throws -> [Product] {
        let response: [ProductDTO] = try await client
            .from("products")
            .select()
            .execute()
            .value
        
        return response.map { $0.toEntity() }
    }
    
    func fetchProduct(id: UUID) async throws -> Product {
        let response: ProductDTO = try await client
            .from("products")
            .select()
            .eq("id", value: id.uuidString)
            .single()
            .execute()
            .value
        
        return response.toEntity()
    }
    
    func addProduct(product: Product) async throws {
        let dto = ProductDTO(
            id: nil,
            name: product.name,
            price: product.price,
            description: product.description,
            imageUrl: product.imageUrl,
            createdAt: nil
        )
        
        try await client
            .from("products")
            .insert(dto)
            .execute()
    }
    
    func updateProduct(product: Product) async throws {
        let dto = ProductDTO(
            id: product.id,
            name: product.name,
            price: product.price,
            description: product.description,
            imageUrl: product.imageUrl,
            createdAt: product.createdAt
        )
        
        try await client
            .from("products")
            .update(dto)
            .eq("id", value: product.id.uuidString)
            .execute()
    }
    
    func deleteProduct(id: UUID) async throws {
        try await client
            .from("products")
            .delete()
            .eq("id", value: id.uuidString)
            .execute()
    }
}
