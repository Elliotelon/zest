//
//  DynamicExecutable.swift
//  ZestCore
//
//  Created by 김민규 on 1/29/26.
//

public protocol DynamicExecutable {
    associatedtype Input: Sendable
    associatedtype Output: Sendable
    
    @MainActor
    func execute(args: Input) async throws -> Output
}
