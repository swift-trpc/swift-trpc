//
//  TrpcRequestType.swift
//  swift-trpc
//
//  Created by Artem Tarasenko on 15.11.2024.
//

/// Type of tRPC request, determining how it's sent to the server.
public enum TrpcRequestType {
    /// Read operation sent as GET request.
    /// Used for fetching data without side effects.
    case query

    /// Write operation sent as POST request.
    /// Used for operations that modify server state.
    case mutation
}
