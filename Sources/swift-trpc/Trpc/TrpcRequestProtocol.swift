//
//  TrpcClientRequestProtocol.swift
//  swift-trpc
//
//  Created by Artem Tarasenko on 15.11.2024.
//

import Foundation

public protocol TrpcRequestProtocol {
    var type: TrpcRequestType { get }
    var path: String { get }
    var headers: [String:String] { get }
    var hasInputData: Bool { get }
    
    func serializeInput() throws -> Data?
}


