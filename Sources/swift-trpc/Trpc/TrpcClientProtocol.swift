//
//  TrpcClientProtocol.swift
//  swift-trpc
//
//  Created by Artem Tarasenko on 15.11.2024.
//

/// Protocol defining a tRPC client for making type-safe RPC calls to a tRPC server.
/// Supports both single and batch requests for queries and mutations.
public protocol TrpcClientProtocol {
    /// Base URL of the tRPC server
    var serverUrl: String { get }

    /// Default headers included in all requests (e.g. auth tokens)
    var baseHeaders: [String: String] { get }

    /// Executes a single tRPC request
    ///
    /// - Parameters:
    ///   - request: The request to execute
    ///   - responseType: Expected response type
    /// - Returns: `TrpcResponse` containing either:
    ///   - `result`: Decoded response data of type `T` if successful
    ///   - `error`: Error details if the request failed but returned a valid tRPC error response
    /// - Throws:
    ///   - `HttpRequestError.invalidServerUrl`: Invalid server URL format
    ///   - `HttpRequestError.invalidPath`: Invalid request path
    ///   - `HttpRequestError.couldntBuildUrl`: URL construction failed
    ///   - Decoding errors if response doesn't match expected type
    ///   - URLError for network-related failures
    @discardableResult
    func execute<T>(
        request: any TrpcRequestProtocol,
        responseType: T.Type
    ) async throws -> TrpcResponse<T> where T: Decodable

    /// Executes multiple requests in a single batch. All requests must be same type (query/mutation).
    ///
    /// - Parameter requests: Array of requests to execute
    /// - Returns: `TrpcBatchResponseProtocol` with indexed access to individual responses
    /// - Throws:
    ///   - `TrpcError.batchRequestEmpty`: Empty request array
    ///   - `TrpcError.batchRequestTypesDiffer`: Mixed query/mutation requests
    ///   - `TrpcError.invalidBatchResponseData`: Invalid batch response format
    ///   - `HttpRequestError.invalidServerUrl`: Invalid server URL format
    ///   - `HttpRequestError.invalidPath`: Invalid request path
    ///   - `HttpRequestError.couldntBuildUrl`: URL construction failed
    ///   - URLError for network-related failures
    @discardableResult
    func executeBatch(requests: [any TrpcRequestProtocol]) async throws -> TrpcBatchResponseProtocol
}
