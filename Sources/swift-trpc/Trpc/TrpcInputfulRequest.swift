//
//  TrpcContentfulRequest.swift
//  swift-trpc
//
//  Created by Artem Tarasenko on 16.11.2024.
//

import Foundation

/// A tRPC request that includes input data to be sent to the server.
/// Generic parameter `TInput` defines the type of input data and must conform to `Encodable`.
public struct TrpcInputfulRequest<TInput>: TrpcRequestProtocol where TInput: Encodable {
    public var type: TrpcRequestType
    public var path: String
    public var headers: [String: String]
    public var input: TInput

    /// Always true as this request type contains input data
    public let hasInputData: Bool = true

    private var jsonEncoder: JSONEncoder

    /// Creates a new request with input data
    ///
    /// - Parameters:
    ///   - type: Type of request (.query or .mutation)
    ///   - path: tRPC procedure path
    ///   - headers: Optional custom headers
    ///   - input: Data to send with the request
    ///   - jsonEncoder: Optional custom JSON encoder (uses default if not provided)
    public init(
        type: TrpcRequestType,
        path: String,
        headers: [String: String] = [:],
        input: TInput,
        jsonEncoder: JSONEncoder = JSONEncoder()
    ) {
        self.type = type
        self.path = path
        self.headers = headers
        self.input = input
        self.jsonEncoder = jsonEncoder
    }

    public func serializeInput() throws -> Data? {
        try self.jsonEncoder.encode(self.input)
    }
}
