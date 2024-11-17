//
//  TrpcError.swift
//  swift-trpc
//
//  Created by Artem Tarasenko on 17.11.2024.
//

/// Errors specific to tRPC client operations.
public enum TrpcError: Error {
    /// Thrown when batch response data isn't in expected format.
    /// Usually indicates server response isn't a valid JSON array.
    case invalidBatchResponseData
    
    /// Thrown when attempting to batch requests with different types.
    /// All requests in a batch must be either all queries or all mutations.
    case batchRequestTypesDiffer
    
    /// Thrown when attempting to execute an empty batch request.
    /// At least one request must be provided.
    case batchRequestEmpty
}
