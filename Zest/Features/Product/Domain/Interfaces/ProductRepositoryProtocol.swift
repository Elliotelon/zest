import Foundation

protocol ProductRepositoryProtocol: Sendable {

    func fetchProducts() async throws -> [Product]
    
    /// 페이지네이션을 지원하는 상품 목록을 가져옵니다.
    /// - Parameters:
    ///   - offset: 시작 인덱스
    ///   - limit: 가져올 개수
    /// - Returns: 상품 배열
    func fetchProducts(offset: Int, limit: Int) async throws -> [Product]
    
    /// 특정 상품의 상세 정보를 가져옵니다.
    func fetchProduct(id: UUID) async throws -> Product
    
    /// 새로운 상품을 추가합니다.
    func addProduct(product: Product) async throws
    
    /// 기존 상품 정보를 업데이트합니다.
    func updateProduct(product: Product) async throws
    
    /// 상품을 삭제합니다.
    func deleteProduct(id: UUID) async throws
}
