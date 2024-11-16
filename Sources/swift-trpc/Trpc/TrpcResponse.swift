//
//  TrpcResponse.swift
//  swift-trpc
//
//  Created by Artem Tarasenko on 17.11.2024.
//

public struct TrpcResponse<TResultData: Decodable>: Decodable {
    var result: TrpcResponseResult<TResultData>?
    var error: TrpcResponseError?
}

public struct TrpcResponseResult<TData: Decodable>: Decodable {
    var data: TData
}

public struct TrpcResponseError: Decodable {
    var code: Int
    var message: String
}
