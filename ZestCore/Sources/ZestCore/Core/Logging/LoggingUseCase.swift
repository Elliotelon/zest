//
//  LoggingUseCase.swift
//  ZestCore
//
//  Created by 김민규 on 1/29/26.
//

import Foundation

public final class LoggingUseCase<U: DynamicExecutable>: DynamicExecutable {
    public typealias Input = U.Input
    public typealias Output = U.Output
    
    private let decorated: U
    private let logger: any Logger
    private let screen: String?
    
    public init(decorated: U, logger: any Logger, screen: String? = nil) {
        self.decorated = decorated
        self.logger = logger
        self.screen = screen
    }
    
    @MainActor
    public func execute(args: Input) async throws -> Output {
        let trace = TraceContext(traceId: UUID().uuidString, screen: screen)
        logger.info("➡️ Execute \(U.self) with \(args)", trace: trace)
        
        do {
            let result = try await decorated.execute(args: args)
            logger.info("⬅️ Execute \(U.self) succeeded with \(result)", trace: trace)
            return result
        } catch {
            logger.error("❌ Execute \(U.self) failed", trace: trace, error: error)
            throw error
        }
    }
}
