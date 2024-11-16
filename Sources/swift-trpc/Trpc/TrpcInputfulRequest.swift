//
//  TrpcContentfulRequest.swift
//  swift-trpc
//
//  Created by Artem Tarasenko on 16.11.2024.
//

import Foundation

public struct TrpcInputfulRequest<TInput>: TrpcRequestProtocol where TInput : Encodable {
    public var type: TrpcRequestType
    public var path: String
    public var headers: [String : String]
    public var input: TInput
    public let hasInputData: Bool = true
    
    private var jsonEncoder: JSONEncoder

    public init(type: TrpcRequestType, path: String, headers: [String : String] = [:], input: TInput, jsonEncoder: JSONEncoder = JSONEncoder()) {
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
