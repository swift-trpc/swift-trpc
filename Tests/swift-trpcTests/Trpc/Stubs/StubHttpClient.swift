//
//  StubHttpClient.swift
//  swift-trpc
//
//  Created by Artem Tarasenko on 17.11.2024.
//

import Foundation
@testable import swift_trpc

class StubHttpClient: HttpClientProtocol {
    var serverUrl: String
    
    public var executedRequests: [HttpClientRequestProtocol] = []
    
    public var response: HttpClientResponseProtocol
    
    init(serverUrl: String, response: HttpClientResponseProtocol, status: Int, body: Data?) {
        self.serverUrl = serverUrl
        
        self.response = response
    }
    
    func execute(request: any HttpClientRequestProtocol) async throws -> any HttpClientResponseProtocol {
        self.executedRequests.append(request)
        
        return self.response
    }
}
