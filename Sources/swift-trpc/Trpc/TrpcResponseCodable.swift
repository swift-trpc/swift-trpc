//
//  TrpcResponse.swift
//  swift-trpc
//
//  Created by Artem Tarasenko on 17.11.2024.
//

internal struct TrpcResponseCodable<TResultData: Decodable>: Decodable {
    var result: TrpcResponseCodableResult<TResultData>?
    var error: TrpcResponseCodableError?
}

internal struct TrpcResponseCodableResult<TData: Decodable>: Decodable {
    var data: TData?
}

internal struct TrpcResponseCodableError: Decodable {
    var code: Int
    var message: String
    var data: TrpcResponseCodableErrorData
}

internal struct TrpcResponseCodableErrorData: Decodable {
    var code: String
    var httpStatus: Int
    var stack: String?
    var path: String?
}
