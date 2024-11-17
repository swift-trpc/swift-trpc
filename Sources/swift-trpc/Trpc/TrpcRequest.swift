//
//  TrpcRequest.swift
//  swift-trpc
//
//  Created by Artem Tarasenko on 16.11.2024.
//

import Foundation

/// Basic implementation of `TrpcRequestProtocol` for requests without input data.
/// Used for simple queries and mutations that don't require parameters.
public struct TrpcRequest: TrpcRequestProtocol {
    public var type: TrpcRequestType
    public var path: String
    public var headers: [String : String]
    
    /// Always false as this request type contains no input data
    public let hasInputData: Bool = false
    
    /// Always returns nil as this request type has no input
    public func serializeInput() throws -> Data? {
        nil
    }
    
    /// Creates a new request without input data
    ///
    /// - Parameters:
    ///   - type: Type of request (.query or .mutation)
    ///   - path: tRPC procedure path
    ///   - headers: Optional custom headers (empty by default)
    public init(type: TrpcRequestType, path: String, headers: [String : String] = [:]) {
        self.type = type
        self.path = path
        self.headers = headers
    }
}
