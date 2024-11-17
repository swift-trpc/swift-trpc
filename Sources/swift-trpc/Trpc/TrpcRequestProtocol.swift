//
//  TrpcClientRequestProtocol.swift
//  swift-trpc
//
//  Created by Artem Tarasenko on 15.11.2024.
//

import Foundation

/// Protocol defining a tRPC request structure.
/// Used to represent both queries and mutations in a type-safe way.
public protocol TrpcRequestProtocol {
    /// Determines if the request is a query or mutation.
    /// Affects how the request is sent (GET vs POST)
    var type: TrpcRequestType { get }
    
    /// Path to the tRPC procedure (e.g. "user.profile" or "posts.create")
    var path: String { get }
    
    /// Request-specific headers that will be merged with client's baseHeaders
    var headers: [String:String] { get }
    
    /// Indicates if the request contains input data to be sent
    var hasInputData: Bool { get }
    
    /// Serializes request input data if present
    ///
    /// - Returns: JSON-encoded input data or nil if no input
    /// - Throws: Encoding errors if input serialization fails
    func serializeInput() throws -> Data?
}


