//
//  TrpcClientProtocol.swift
//  swift-trpc
//
//  Created by Artem Tarasenko on 15.11.2024.
//

public protocol TrpcClientProtocol {
    var serverUrl: String { get }
    
    func mutate() async throws -> AnyObject
    func query() async throws -> AnyObject
}
