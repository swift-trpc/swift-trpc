//
//  TrpcResponse.swift
//  swift-trpc
//
//  Created by Artem Tarasenko on 17.11.2024.
//

/// Represents a response from a tRPC procedure call.
/// Generic parameter `TResult` defines the expected result type.
public struct TrpcResponse<TResult> where TResult: Decodable {
    /// Successfully decoded response data, if present.
    /// Will be nil if the request resulted in an error or doesn't have a response body (returns nothing)
    public let result: TResult?

    /// Error information if the request failed.
    /// Will be nil if the request was successful.
    public let error: TrpcResponseError?

    internal init(from: TrpcResponseCodable<TResult>) {
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

/// Represents error information returned by tRPC server
public struct TrpcResponseError {
    /// tRPC-specific error code (https://trpc.io/docs/rpc#error-codes---json-rpc-20-error-codes)
    public let rpcCode: Int

    /// HTTP status code associated with the error
    public let httpStatus: Int

    /// Error message from the server
    public let message: String

    /// tRPC error code
    public let errorCode: String

    /// Stack trace if provided by server
    public let errorStack: String?

    /// Path where error occurred
    public let errorPath: String?

    internal init(from: TrpcResponseCodableError) {
        self.rpcCode = from.code
        self.httpStatus = from.data.httpStatus
        self.message = from.message
        self.errorCode = from.data.code
        self.errorStack = from.data.stack
        self.errorPath = from.data.path
    }
}
