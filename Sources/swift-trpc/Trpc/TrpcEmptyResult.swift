//
//  TrpcEmptyResult.swift
//  swift-trpc
//
//  Created by Artem Tarasenko on 17.11.2024.
//


/// Should be used as type parameter of `TrpcClientProtocol.execute<T>` if empty result is returned from endpoint
public struct TrpcEmptyResult: Codable { }
