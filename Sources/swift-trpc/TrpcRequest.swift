//
//  TrpcClientRequestProtocol.swift
//  swift-trpc
//
//  Created by Artem Tarasenko on 15.11.2024.
//

public protocol TrpcRequest {
    associatedtype TInput: Encodable
    
    var type: TrpcRequestType { get }
    var path: String { get }
    var input: TInput? { get }
    var headers: [String:String] { get }
}


