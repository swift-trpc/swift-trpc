//
//  TrpcBatchResponseProtocol.swift
//  swift-trpc
//
//  Created by Artem Tarasenko on 17.11.2024.
//

public protocol TrpcBatchResponseProtocol {
    func get<T>(index: Int, responseType: T.Type) throws -> TrpcResponse<T> where T: Decodable;
}
