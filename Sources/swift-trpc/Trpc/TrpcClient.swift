//
//  TrpcClient.swift
//  swift-trpc
//
//  Created by Artem Tarasenko on 15.11.2024.
//

import Foundation

@available(iOS 13, macOS 10.15, *)
public class TrpcClient: TrpcClientProtocol {
    private let httpClient: HttpClientProtocol
    private let jsonDecoder: JSONDecoder
    
    public var baseHeaders: [String : String]
    public var serverUrl: String {
        get {
            httpClient.serverUrl
        }
    }
    
    public init(serverUrl: String, urlSession: URLSession = URLSession.shared, jsonDecoder: JSONDecoder = JSONDecoder()) {
        self.httpClient = HttpClient(serverUrl: serverUrl, urlSession: urlSession)
        self.baseHeaders = [:]
        self.jsonDecoder = jsonDecoder
    }
    
    internal init(serverUrl: String, httpClient: HttpClientProtocol, jsonDecoder: JSONDecoder = JSONDecoder()) {
        self.httpClient = httpClient
        self.baseHeaders = [:]
        self.jsonDecoder = jsonDecoder
    }

    public func execute<T>(request: any TrpcRequestProtocol, responseType: T.Type) async throws -> TrpcResponse<T> where T : Decodable {
        let httpRequest = try request.getHttpRequestForClient(trpcClient: self)
        let response = try await httpClient.execute(request: httpRequest)
        
        let decoded = try self.jsonDecoder.decode(TrpcResponse<T>.self, from: response.body)
        
        return decoded
    }
}
