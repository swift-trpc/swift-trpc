//
//  TrpcClient.swift
//  swift-trpc
//
//  Created by Artem Tarasenko on 15.11.2024.
//

import Foundation

/// Default implementation of `TrpcClientProtocol` for making tRPC calls.
/// Handles HTTP communication, request serialization, and response parsing.
@available(iOS 13, macOS 10.15, *)
public class TrpcClient: TrpcClientProtocol {
    private let httpClient: HttpClientProtocol
    private let jsonDecoder: JSONDecoder
    
    public var baseHeaders: [String : String] = [
        "content-type": "application/json"
    ]
    
    public var serverUrl: String {
        get {
            httpClient.serverUrl
        }
    }
    
    /// Creates new tRPC client
    ///
    /// - Parameters:
    ///   - serverUrl: Base URL of the tRPC server
    ///   - urlSession: URLSession for network requests (uses shared by default)
    ///   - jsonDecoder: Custom JSON decoder (uses default if not provided)
    public init(serverUrl: String, urlSession: URLSession = URLSession.shared, jsonDecoder: JSONDecoder = JSONDecoder()) {
        self.httpClient = HttpClient(serverUrl: serverUrl, urlSession: urlSession)
        self.jsonDecoder = jsonDecoder
    }
    
    internal init(httpClient: HttpClientProtocol, jsonDecoder: JSONDecoder = JSONDecoder()) {
        self.httpClient = httpClient
        self.jsonDecoder = jsonDecoder
    }

    @discardableResult
    public func execute<T>(request: any TrpcRequestProtocol, responseType: T.Type) async throws -> TrpcResponse<T> where T : Decodable {
        let httpRequest = try request.asHttpRequest(trpcClient: self)
        let response = try await httpClient.execute(request: httpRequest)
        
        let decoded = try self.jsonDecoder.decode(TrpcResponseCodable<T>.self, from: response.body)
        
        return TrpcResponse<T>(from: decoded)
    }
    
    @discardableResult
    public func executeBatch(requests: [any TrpcRequestProtocol]) async throws -> TrpcBatchResponseProtocol {
        let request = try TrpcBatchRequest(requests: requests, trpcClient: self)
        let response = try await self.httpClient.execute(request: request)
        
        return try TrpcBatchResponse(from: response.body, jsonDecoder: self.jsonDecoder)
    }
}
