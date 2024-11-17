//
//  TrpcResponse.swift
//  swift-trpc
//
//  Created by Artem Tarasenko on 17.11.2024.
//

public struct TrpcResponse<TResult> where TResult: Decodable {
    public let result: TResult?
    public let error: TrpcResponseError?
    
    init(from: TrpcResponseCodable<TResult>) {
        if let result = from.result {
            self.result = result.data
        } else {
            self.result = nil
        }
        
        if let error = from.error {
            self.error = TrpcResponseError(from: error)
        } else {
            self.error = nil
        }
    }
}

public struct TrpcResponseError {
    public let rpcCode: Int
    public let httpStatus: Int
    public let message: String
    
    public let errorCode: String
    public let errorStack: String?
    public let errorPath: String?
    
    init(from: TrpcResponseCodableError) {
        self.rpcCode = from.code
        self.httpStatus = from.data.httpStatus
        self.message = from.message
        self.errorCode = from.data.code
        self.errorStack = from.data.stack
        self.errorPath = from.data.path
    }
}
