//
//  MockTrpcClient.swift
//  swift-trpc
//
//  Created by Artem Tarasenko on 16.11.2024.
//

import swift_trpc

internal class StubTrpcClient: TrpcClientProtocol {
    public static let stubServerUrl = "http://server.com"
    
    let serverUrl: String = StubTrpcClient.stubServerUrl
    
    public var baseHeaders: [String : String] = [:]
    
    func execute<T>(request: any TrpcRequestProtocol, responseType: T.Type) async throws -> TrpcResponse<T> where T : Decodable {
        // Ignore for now
        fatalError("Not implemented!")
    }
}
