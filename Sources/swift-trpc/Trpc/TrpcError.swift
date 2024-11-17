//
//  TrpcError.swift
//  swift-trpc
//
//  Created by Artem Tarasenko on 17.11.2024.
//

public enum TrpcError: Error {
    case invalidBatchResponseData
    case batchRequestTypesDiffer
    case batchRequestEmpty
}
