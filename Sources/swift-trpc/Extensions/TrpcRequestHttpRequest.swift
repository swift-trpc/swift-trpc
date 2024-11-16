//
//  TrpcRequestHttpRequest.swift
//  swift-trpc
//
//  Created by Artem Tarasenko on 15.11.2024.
//

import Foundation

internal extension TrpcRequestProtocol {
    func getHttpRequestForClient(trpcClient: TrpcClientProtocol) throws -> HttpClientRequestProtocol {
        return HttpClientRequest(
            path: self.path,
            method: HttpMethod(rawValue: self.type == .mutation ? "POST" : "GET") ?? .get,
            headers: trpcClient.baseHeaders.merged(with: self.headers),
            query: try getQuery(),
            body: try getBody()
        )
    }
    
    private func getQuery() throws -> [String:String] {
        if self.type == .mutation {
            return [:]
        }
        
        if self.hasInputData, let data = try self.serializeInput() {
            let str = String(decoding: data, as: UTF8.self)
            
            return [
                "input": str
            ]
        }
        
        return [:]
    }
    
    private func getBody() throws -> Data? {
        if self.hasInputData, self.type == .mutation {
            return try self.serializeInput()
        }
        
        return nil
    }
}
