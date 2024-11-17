//
//  TrpcRequestTests.swift
//  swift-trpc
//
//  Created by Artem Tarasenko on 16.11.2024.
//

import Testing
import Foundation
@testable import swift_trpc

struct TrpcRequestHttpRequestTests {
    @Test func queryRequestReturnsHttpRequestWithGetMethod() async throws {
        let trpcClient = StubTrpcClient()
        let trpcRequest = TrpcRequest(type: .query, path: "trpc.method")
        let httpRequest = try trpcRequest.asHttpRequest(trpcClient: trpcClient)

        #expect(httpRequest.method == .get)
    }

    @Test func mutationRequestReturnsHttpRequestWithPostMethod() async throws {
        let trpcClient = StubTrpcClient()
        let trpcRequest = TrpcRequest(type: .mutation, path: "trpc.method")
        let httpRequest = try trpcRequest.asHttpRequest(trpcClient: trpcClient)

        #expect(httpRequest.method == .post)
    }

    @Test func returnsHttpRequestWithValidPath() async throws {
        let trpcClient = StubTrpcClient()
        let trpcRequest = TrpcRequest(type: .query, path: "trpc.method")
        let httpRequest = try trpcRequest.asHttpRequest(trpcClient: trpcClient)

        #expect(httpRequest.path == trpcRequest.path)
    }

    @Test func returnsHttpRequestWithTrpcClientBaseHeaders() async throws {
        let trpcClient = StubTrpcClient()
        trpcClient.baseHeaders["user-agent"] = "swift-testing"

        let trpcRequest = TrpcRequest(type: .mutation, path: "trpc.method")
        let httpRequest = try trpcRequest.asHttpRequest(trpcClient: trpcClient)

        #expect(httpRequest.headers["user-agent"] == "swift-testing")
    }

    @Test func returnsHttpRequestWithTrpcClientAndOwnMergedHeaders() async throws {
        let trpcClient = StubTrpcClient()
        trpcClient.baseHeaders["user-agent"] = "swift-testing"

        let trpcRequest = TrpcRequest(type: .mutation, path: "trpc.method", headers: [
            "user-agent": "swift-trpc-testing",
            "authorization": "Bearer my_token"
        ])
        let httpRequest = try trpcRequest.asHttpRequest(trpcClient: trpcClient)

        // Rewrites the user-agent header of trpc client with request's one
        #expect(httpRequest.headers["user-agent"] == "swift-trpc-testing")

        // Adds the request-specific header
        #expect(httpRequest.headers["authorization"] == "Bearer my_token")
    }

    @Test func mutationRequestWithInputReturnsSerializedInputInBody() async throws {
        let trpcClient = StubTrpcClient()

        let dataString = "my_example_data"
        let data = dataString.data(using: .utf8)!
        let trpcRequest = StubTrpcRequestWithInput(type: .mutation, path: "trpc.method", input: data)

        let httpRequest = try trpcRequest.asHttpRequest(trpcClient: trpcClient)

        let httpRequestBody = httpRequest.body

        #expect(httpRequestBody != nil)

        let httpRequestBodyString = String(data: httpRequestBody!, encoding: .utf8)

        #expect(httpRequestBodyString == dataString)
    }

    @Test func mutationRequestWithInputReturnsEmptyQuery() async throws {
        let trpcClient = StubTrpcClient()

        let dataString = "my_example_data"
        let data = dataString.data(using: .utf8)!
        let trpcRequest = StubTrpcRequestWithInput(type: .mutation, path: "trpc.method", input: data)

        let httpRequest = try trpcRequest.asHttpRequest(trpcClient: trpcClient)

        #expect(httpRequest.query.count == 0)
    }

    @Test func queryRequestWithInputReturnsSerializedInputInQuery() async throws {
        let trpcClient = StubTrpcClient()

        let dataString = "my_example_data"
        let data = dataString.data(using: .utf8)!
        let trpcRequest = StubTrpcRequestWithInput(type: .query, path: "trpc.method", input: data)

        let httpRequest = try trpcRequest.asHttpRequest(trpcClient: trpcClient)
        let httpRequestInput = httpRequest.query["input"]

        #expect(httpRequestInput != nil)
        #expect(httpRequestInput! == dataString)
    }

    @Test func queryRequestWithInputReturnsEmptyBody() async throws {
        let trpcClient = StubTrpcClient()

        let dataString = "my_example_data"
        let data = dataString.data(using: .utf8)!
        let trpcRequest = StubTrpcRequestWithInput(type: .query, path: "trpc.method", input: data)

        let httpRequest = try trpcRequest.asHttpRequest(trpcClient: trpcClient)

        #expect(httpRequest.body == nil)
    }
}
