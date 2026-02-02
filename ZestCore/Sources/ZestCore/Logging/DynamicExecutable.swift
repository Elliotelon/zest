public protocol DynamicExecutable {
    associatedtype Input: Sendable
    associatedtype Output: Sendable
    
    @MainActor
    func execute(args: Input) async throws -> Output
}
