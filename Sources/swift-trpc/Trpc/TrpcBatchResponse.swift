//
//  TrpcBatchResponse.swift
//  swift-trpc
//
//  Created by Artem Tarasenko on 17.11.2024.
//

import Foundation

public struct TrpcBatchResponse: TrpcBatchResponseProtocol {
    private var responses: [Any]
    private var jsonDecoder: JSONDecoder
    
    internal init(from: Data, jsonDecoder: JSONDecoder = JSONDecoder()) throws {
        self.jsonDecoder = jsonDecoder
        
        let serializationResult = try JSONSerialization.jsonObject(with: from)
        
        if let serializationResult = serializationResult as? [Any] {
            self.responses = serializationResult
        } else {
            throw TrpcError.invalidBatchResponseData
        }
    }
    
    public func get<T>(index: Int, responseType: T.Type) throws -> TrpcResponse<T> where T : Decodable {
        let response = self.responses[index]
        let responseData = try JSONSerialization.data(withJSONObject: response)
        let result = try self.jsonDecoder.decode(TrpcResponseCodable<T>.self, from: responseData)
        
        return TrpcResponse(from: result)
    }
}
