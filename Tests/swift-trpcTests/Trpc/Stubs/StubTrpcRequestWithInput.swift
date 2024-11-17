//
//  StubTrpcRequest.swift
//  swift-trpc
//
//  Created by Artem Tarasenko on 17.11.2024.
//

import Foundation
import swift_trpc

struct StubTrpcRequestWithInput: TrpcRequestProtocol {
    var type: TrpcRequestType

    var path: String

    var headers: [String: String]

    public let hasInputData: Bool = true

    private var inputData: Data

    func serializeInput() throws -> Data? {
        self.inputData
    }

    init(type: TrpcRequestType, path: String, headers: [String: String] = [:], input: Data) {
        self.type = type
        self.path = path
        self.headers = headers
        self.inputData = input
    }
}
