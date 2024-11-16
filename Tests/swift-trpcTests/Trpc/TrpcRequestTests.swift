//
//  TrpcRequestTests.swift
//  swift-trpc
//
//  Created by Artem Tarasenko on 17.11.2024.
//

import Testing
@testable import swift_trpc

struct TrpcRequestTests {
    @Test func returnsFalseOnHasInputData() async throws {
        let trpcRequest = TrpcRequest(type: .query, path: "trpc.method")
        #expect(trpcRequest.hasInputData == false)
    }
    
    @Test func returnsNilOnSerializeInput() async throws {
        let trpcRequest = TrpcRequest(type: .query, path: "trpc.method")
        #expect(try trpcRequest.serializeInput() == nil)
    }
}
