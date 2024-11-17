//
//  TrpcRequest.swift
//  swift-trpc
//
//  Created by Artem Tarasenko on 16.11.2024.
//

import Foundation

public struct TrpcRequest: TrpcRequestProtocol {
    public var type: TrpcRequestType
    public var path: String
    public var headers: [String : String]
    public let hasInputData: Bool = false
    
    public func serializeInput() throws -> Data? {
        nil
    }
    
    public init(type: TrpcRequestType, path: String, headers: [String : String] = [:]) {
        self.type = type
        self.path = path
        self.headers = headers
    }
}
