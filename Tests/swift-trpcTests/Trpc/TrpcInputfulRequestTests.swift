//
//  TrpcInputfulRequestTests.swift
//  swift-trpc
//
//  Created by Artem Tarasenko on 17.11.2024.
//

import Testing
@testable import swift_trpc

struct TrpcInputfulRequestTests {
    @Test func returnsTrueOnHasInputData() async throws {
        let trpcRequest = TrpcInputfulRequest(type: .query, path: "trpc.method", input: "Hello, world")
        #expect(trpcRequest.hasInputData == true)
    }
    
    @Test func returnsJSONSerializedDataOnSerializeInput() async throws {
        let input = "Hello, world"
        let trpcRequest = TrpcInputfulRequest(type: .query, path: "trpc.method", input: input)
        
        let serializedInput = try trpcRequest.serializeInput()
        
        #expect(serializedInput != nil)
        
        let serializedInputString = String(data: serializedInput!, encoding: .utf8)
        #expect(serializedInputString! == "\"\(input)\"")
    }
}
