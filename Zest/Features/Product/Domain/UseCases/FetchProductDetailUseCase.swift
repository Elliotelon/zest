import Foundation

final class FetchProductDetailUseCase: Sendable {
    private let repository: ProductRepositoryProtocol
    
    init(repository: ProductRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(productId: UUID) async throws -> Product {
        return try await repository.fetchProduct(id: productId)
    }
}
