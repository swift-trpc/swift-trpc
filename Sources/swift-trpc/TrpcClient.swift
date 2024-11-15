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
    
    public var baseHeaders: [String : String]
    public var serverUrl: String {
        get {
            httpClient.serverUrl
        }
    }
    
    init(serverUrl: String) {
        self.httpClient = HttpClient(serverUrl: serverUrl)
        self.baseHeaders = [:]
    }
    
    public func execute<T>(request: any TrpcRequest, responseType: T.Type) async throws -> AnyObject where T : Decodable {
        let decoder = JSONDecoder()
        
        let httpRequest = try request.getHttpRequestForClient(trpcClient: self)
        let response = try await httpClient.execute(request: httpRequest)
        
        let decoded = try decoder.decode(responseType, from: response.body)
        
        return decoded as AnyObject
    }
}
