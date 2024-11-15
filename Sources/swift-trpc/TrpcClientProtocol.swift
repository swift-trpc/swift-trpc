//
//  TrpcClientProtocol.swift
//  swift-trpc
//
//  Created by Artem Tarasenko on 15.11.2024.
//

public protocol TrpcClientProtocol {
    var serverUrl: String { get }
    var baseHeaders: [String:String] { get }
    
    func execute<T>(request: any TrpcRequest, responseType: T.Type) async throws -> AnyObject where T : Decodable;
}
