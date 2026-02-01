import SwiftUI
import Combine

@MainActor
final class ProductViewModel: ObservableObject {
    @Published var products: [Product] = []
    @Published var isLoading = false
    @Published var isLoadingMore = false
    @Published var errorMessage: String?
    
    private let fetchProductsUseCase: FetchProductsUseCase
    private let pageSize = 20
    private var currentOffset = 0
    private var hasMoreData = true
    
    init(fetchProductsUseCase: FetchProductsUseCase) {
        self.fetchProductsUseCase = fetchProductsUseCase
    }
    
    /// 초기 상품 목록을 로드합니다.
    func loadProducts() async {
        guard !isLoading else { return }
        
        isLoading = true
        errorMessage = nil
        currentOffset = 0
        hasMoreData = true
        
        do {
            let newProducts = try await fetchProductsUseCase.execute(offset: 0, limit: pageSize)
            products = newProducts
            currentOffset = newProducts.count
            hasMoreData = newProducts.count == pageSize
            print("✅ 상품 데이터 로드 성공: \(products.count)개")
        } catch {
            errorMessage = error.localizedDescription
            print("❌ 상품 데이터 로드 실패: \(error)")
        }
        
        isLoading = false
    }
    
    /// 추가 상품 목록을 로드합니다. (무한 스크롤)
    func loadMoreProducts() async {
        // 중복 호출 방지: 이미 로딩 중이거나, 초기 로딩 중이거나, 더 이상 데이터가 없으면 리턴
        guard !isLoadingMore, !isLoading, hasMoreData else {
            return
        }
        
        isLoadingMore = true
        do {
            let newProducts = try await fetchProductsUseCase.execute(offset: currentOffset, limit: pageSize)
            products.append(contentsOf: newProducts)
            currentOffset += newProducts.count
            hasMoreData = newProducts.count == pageSize
            print("✅ 추가 상품 로드 성공: \(newProducts.count)개 (총 \(products.count)개)")
        } catch {
            errorMessage = error.localizedDescription
            print("❌ 추가 상품 로드 실패: \(error)")
        }
        
        isLoadingMore = false
    }
    
    /// 특정 상품이 프리페칭 트리거인지 확인합니다.
    /// - Parameter product: 확인할 상품
    /// - Returns: 마지막에서 5번째 아이템이면 true
    func shouldLoadMore(currentItem product: Product) -> Bool {
        guard let index = products.firstIndex(where: { $0.id == product.id }) else {
            return false
        }
        return index == products.count - 5
    }
}
