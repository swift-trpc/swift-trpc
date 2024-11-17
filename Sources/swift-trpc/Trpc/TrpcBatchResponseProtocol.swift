//
//  TrpcBatchResponseProtocol.swift
//  swift-trpc
//
//  Created by Artem Tarasenko on 17.11.2024.
//

/// Implementation of `TrpcBatchResponseProtocol` that handles deserialization and access
/// to individual responses from a batch request.
public protocol TrpcBatchResponseProtocol {
    /// Retrieves and decodes a single response from the batch by index
    ///
    /// - Parameters:
    ///   - index: Position of the response in the batch (zero-based)
    ///   - responseType: Expected type of the response data
    /// - Returns: `TrpcResponse` containing either:
    ///   - `result`: Decoded response data of type `T` if successful
    ///   - `error`: Error details if the request failed but returned a valid tRPC error response
    /// - Throws:
    ///   - `JSONError` if response can't be decoded to specified type
    ///   - Index out of bounds error if invalid index provided
    func get<T>(index: Int, responseType: T.Type) throws -> TrpcResponse<T> where T: Decodable;
}
