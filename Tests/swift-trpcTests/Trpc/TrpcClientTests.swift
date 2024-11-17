//
//  TrpcClientTests.swift
//  swift-trpc
//
//  Created by Artem Tarasenko on 17.11.2024.
//

import Testing
import Foundation
@testable import swift_trpc

struct TrpcClientTests {
    @Test func sendsRequestOnlyOnce() async throws {
        let serializedResponse = #"{"result":{"data":{"healthy":true}}}"#
        let serializedResponseData = serializedResponse.data(using: .utf8)!
        let response = HttpClientResponse(request: nil, status: 200, body: serializedResponseData)
        let httpClient = StubHttpClient(serverUrl: "http://myserver.host", response: response)
        let trpcClient = TrpcClient(httpClient: httpClient)
        let trpcRequest = TrpcRequest(type: .query, path: "trpc.method")
        try await trpcClient.execute(request: trpcRequest, responseType: HealthResponseModel.self)
        
        #expect(httpClient.executedRequests.count == 1)
    }
        
    @Test func returnsDecodedOutput() async throws {
        let serializedResponse = #"{"result":{"data":{"healthy":true}}}"#
        let serializedResponseData = serializedResponse.data(using: .utf8)!
        let response = HttpClientResponse(request: nil, status: 200, body: serializedResponseData)
        let httpClient = StubHttpClient(serverUrl: "http://myserver.host", response: response)
        let trpcClient = TrpcClient(httpClient: httpClient)
        let trpcRequest = TrpcRequest(type: .query, path: "trpc.method")
        let trpcResponse  = try await trpcClient.execute(request: trpcRequest, responseType: HealthResponseModel.self)
        
        #expect(trpcResponse.result != nil)
        #expect(trpcResponse.error == nil)
        #expect(trpcResponse.result!.healthy == true)
    }
    
    @Test func returnsDecodedError() async throws {
        let serializedResponse = #"{"error":{"message":"custom_message","code":-32004,"data":{"code":"NOT_FOUND","httpStatus":404,"stack":"some_stack","path":"error"}}}"#
        
        let serializedResponseData = serializedResponse.data(using: .utf8)!
        let response = HttpClientResponse(request: nil, status: 404, body: serializedResponseData)
        let httpClient = StubHttpClient(serverUrl: "http://myserver.host", response: response)
        let trpcClient = TrpcClient(httpClient: httpClient)
        let trpcRequest = TrpcRequest(type: .query, path: "trpc.method")
        let trpcResponse  = try await trpcClient.execute(request: trpcRequest, responseType: HealthResponseModel.self)
        
        #expect(trpcResponse.result == nil)
        #expect(trpcResponse.error != nil)
        #expect(trpcResponse.error!.rpcCode == -32004)
        #expect(trpcResponse.error!.httpStatus == 404)
        #expect(trpcResponse.error!.errorCode == "NOT_FOUND")
        #expect(trpcResponse.error!.errorStack == "some_stack")
        #expect(trpcResponse.error!.errorPath == "error")
    }
    
    @Test func throwsIfDifferentTypeRequestsInExecuteBatch() async throws {
        await #expect(throws: TrpcError.batchRequestTypesDiffer, performing: {
            let httpClient = StubHttpClient(serverUrl: "http://myserver.host", response: HttpClientResponse(status: 200, body: "{}".data(using: .utf8)!))
            let trpcClient = TrpcClient(httpClient: httpClient)
            
            let requests: [any TrpcRequestProtocol] = [
                TrpcRequest(type: .query, path: "trpc.method1"),
                TrpcRequest(type: .query, path: "trpc.method2"),
                TrpcRequest(type: .mutation, path: "trpc.method3"),
            ]
            
            try await trpcClient.executeBatch(requests: requests)
        })
    }
    
    @Test func throwsIfEmptyArrayPassedAsRequestsInExecuteBatch() async throws {
        await #expect(throws: TrpcError.batchRequestEmpty, performing: {
            let httpClient = StubHttpClient(serverUrl: "http://myserver.host", response: HttpClientResponse(status: 200, body: "{}".data(using: .utf8)!))
            let trpcClient = TrpcClient(httpClient: httpClient)
            
            let requests: [any TrpcRequestProtocol] = []
            
            try await trpcClient.executeBatch(requests: requests)
        })
    }
    
    @Test func sendsValidBatchQueryRequestWithoutInputs() async throws {
        let serializedResponse = "[]"
        
        let serializedResponseData = serializedResponse.data(using: .utf8)!
        let response = HttpClientResponse(request: nil, status: 200, body: serializedResponseData)
        let httpClient = StubHttpClient(serverUrl: "http://myserver.host", response: response)
        let trpcClient = TrpcClient(httpClient: httpClient)
        
        let requests: [any TrpcRequestProtocol] = [
            TrpcRequest(type: .query, path: "trpc.method1"),
            TrpcRequest(type: .query, path: "trpc.method2"),
        ]
        
        _ = try await trpcClient.executeBatch(requests: requests)
        
        #expect(httpClient.executedRequests.count == 1)
        
        let httpRequest = httpClient.executedRequests[0]
        
        #expect(httpRequest.method == .get)
        #expect(httpRequest.path == "trpc.method1,trpc.method2")
        #expect(httpRequest.body == nil)
        #expect(httpRequest.query["input"] == "{}")
    }
    
    @Test func sendsValidBatchQueryRequestWithInputInOneRequest() async throws {
        let serializedResponse = "[]"
        
        let serializedResponseData = serializedResponse.data(using: .utf8)!
        let response = HttpClientResponse(request: nil, status: 200, body: serializedResponseData)
        let httpClient = StubHttpClient(serverUrl: "http://myserver.host", response: response)
        let trpcClient = TrpcClient(httpClient: httpClient)
        
        let input = TestRequestModel(value1: 10, value2: "hello")
        
        let requests: [any TrpcRequestProtocol] = [
            TrpcRequest(type: .query, path: "trpc.method2"),
            TrpcInputfulRequest(type: .query, path: "trpc.method1", input: input),
        ]
        
        _ = try await trpcClient.executeBatch(requests: requests)
        
        #expect(httpClient.executedRequests.count == 1)
        
        let httpRequest = httpClient.executedRequests[0]
        
        #expect(httpRequest.method == .get)
        #expect(httpRequest.path == "trpc.method2,trpc.method1")
        #expect(httpRequest.body == nil)
        #expect(httpRequest.query["batch"] == "1")
        #expect(httpRequest.query["input"] != nil)
        
        let parsedQueryInput = try JSONSerialization.jsonObject(with: httpRequest.query["input"]!.data(using: .utf8)!) as! [String:Any]
        
        #expect(parsedQueryInput.keys.count == 1)
        #expect(parsedQueryInput["0"] == nil)
        #expect(parsedQueryInput["1"] != nil)
        #expect(parsedQueryInput["1"] as? [String:Any] != nil)
        
        let actualInput = parsedQueryInput["1"] as! [String:Any]
        
        #expect(actualInput["value1"] != nil)
        #expect(actualInput["value2"] != nil)
        
        #expect(actualInput["value1"] as! Int == 10)
        #expect(actualInput["value2"] as! String == "hello")
    }
    
    @Test func sendsValidBatchQueryRequestWithMultipleInput() async throws {
        let serializedResponse = "[]"
        
        let serializedResponseData = serializedResponse.data(using: .utf8)!
        let response = HttpClientResponse(request: nil, status: 200, body: serializedResponseData)
        let httpClient = StubHttpClient(serverUrl: "http://myserver.host", response: response)
        let trpcClient = TrpcClient(httpClient: httpClient)
        
        let input1 = TestRequestModel(value1: 10, value2: "hello")
        let input2 = TestRequestModel(value1: 20, value2: "world")
        
        let requests: [any TrpcRequestProtocol] = [
            TrpcInputfulRequest(type: .query, path: "trpc.method1", input: input1),
            TrpcInputfulRequest(type: .query, path: "trpc.method2", input: input2),
        ]
        
        _ = try await trpcClient.executeBatch(requests: requests)
        
        #expect(httpClient.executedRequests.count == 1)
        
        let httpRequest = httpClient.executedRequests[0]
        
        #expect(httpRequest.method == .get)
        #expect(httpRequest.path == "trpc.method1,trpc.method2")
        #expect(httpRequest.body == nil)
        #expect(httpRequest.query["batch"] == "1")
        #expect(httpRequest.query["input"] != nil)
        
        let parsedQueryInput = try JSONSerialization.jsonObject(with: httpRequest.query["input"]!.data(using: .utf8)!) as! [String:Any]
        
        #expect(parsedQueryInput.keys.count == 2)
        
        #expect(parsedQueryInput["0"] != nil)
        #expect(parsedQueryInput["0"] as? [String:Any] != nil)
        
        let actualInput = parsedQueryInput["0"] as! [String:Any]
        
        #expect(actualInput["value1"] != nil)
        #expect(actualInput["value2"] != nil)
        
        #expect(actualInput["value1"] as! Int == 10)
        #expect(actualInput["value2"] as! String == "hello")
        
        #expect(parsedQueryInput["1"] != nil)
        #expect(parsedQueryInput["1"] as? [String:Any] != nil)
        
        let actualInput2 = parsedQueryInput["1"] as! [String:Any]
        
        #expect(actualInput2["value1"] != nil)
        #expect(actualInput2["value2"] != nil)
        
        #expect(actualInput2["value1"] as! Int == 20)
        #expect(actualInput2["value2"] as! String == "world")
    }
    
    @Test func sendsValidBatchMutationRequestWithoutInputs() async throws {
        let serializedResponse = "[]"
        
        let serializedResponseData = serializedResponse.data(using: .utf8)!
        let response = HttpClientResponse(request: nil, status: 200, body: serializedResponseData)
        let httpClient = StubHttpClient(serverUrl: "http://myserver.host", response: response)
        let trpcClient = TrpcClient(httpClient: httpClient)
        
        let requests: [any TrpcRequestProtocol] = [
            TrpcRequest(type: .mutation, path: "trpc.method1"),
            TrpcRequest(type: .mutation, path: "trpc.method2"),
        ]
        
        _ = try await trpcClient.executeBatch(requests: requests)
        
        #expect(httpClient.executedRequests.count == 1)
        
        let httpRequest = httpClient.executedRequests[0]
        
        #expect(httpRequest.method == .post)
        #expect(httpRequest.path == "trpc.method1,trpc.method2")
        #expect(httpRequest.query["batch"] == "1")
        #expect(httpRequest.query["input"] == nil)
        #expect(httpRequest.body != nil)

        let bodyData = try JSONSerialization.jsonObject(with: httpRequest.body!) as! [String:Any]
        
        #expect(bodyData.keys.count == 0)
    }
    
    @Test func sendsValidBatchMutationRequestWithOneInput() async throws {
        let serializedResponse = "[]"
        
        let serializedResponseData = serializedResponse.data(using: .utf8)!
        let response = HttpClientResponse(request: nil, status: 200, body: serializedResponseData)
        let httpClient = StubHttpClient(serverUrl: "http://myserver.host", response: response)
        let trpcClient = TrpcClient(httpClient: httpClient)
        
        let input = TestRequestModel(value1: 10, value2: "hello")
        
        let requests: [any TrpcRequestProtocol] = [
            TrpcRequest(type: .mutation, path: "trpc.method2"),
            TrpcInputfulRequest(type: .mutation, path: "trpc.method1", input: input),
        ]

        _ = try await trpcClient.executeBatch(requests: requests)
        
        #expect(httpClient.executedRequests.count == 1)
        
        let httpRequest = httpClient.executedRequests[0]
        
        #expect(httpRequest.method == .post)
        #expect(httpRequest.path == "trpc.method2,trpc.method1")
        #expect(httpRequest.query["batch"] == "1")
        #expect(httpRequest.query["input"] == nil)
        #expect(httpRequest.body != nil)

        let bodyData = try JSONSerialization.jsonObject(with: httpRequest.body!) as! [String:Any]
        
        #expect(bodyData.keys.count == 1)
        #expect(bodyData["0"] == nil)
        #expect(bodyData["1"] != nil)
        
        #expect(bodyData["1"] as? [String:Any] != nil)
        
        let actualInput = bodyData["1"] as! [String:Any]
        
        #expect(actualInput["value1"] != nil)
        #expect(actualInput["value2"] != nil)
        
        #expect(actualInput["value1"] as! Int == 10)
        #expect(actualInput["value2"] as! String == "hello")
    }
    
    @Test func sendsValidBatchMutationRequestWithMultipleInput() async throws {
        let serializedResponse = "[]"
        
        let serializedResponseData = serializedResponse.data(using: .utf8)!
        let response = HttpClientResponse(request: nil, status: 200, body: serializedResponseData)
        let httpClient = StubHttpClient(serverUrl: "http://myserver.host", response: response)
        let trpcClient = TrpcClient(httpClient: httpClient)
        
        let input1 = TestRequestModel(value1: 10, value2: "hello")
        let input2 = TestRequestModel(value1: 20, value2: "world")

        let requests: [any TrpcRequestProtocol] = [
            TrpcInputfulRequest(type: .mutation, path: "trpc.method1", input: input1),
            TrpcInputfulRequest(type: .mutation, path: "trpc.method2", input: input2),
        ]

        _ = try await trpcClient.executeBatch(requests: requests)
        
        #expect(httpClient.executedRequests.count == 1)
        
        let httpRequest = httpClient.executedRequests[0]
        
        #expect(httpRequest.method == .post)
        #expect(httpRequest.path == "trpc.method1,trpc.method2")
        #expect(httpRequest.query["batch"] == "1")
        #expect(httpRequest.query["input"] == nil)
        #expect(httpRequest.body != nil)

        let bodyData = try JSONSerialization.jsonObject(with: httpRequest.body!) as! [String:Any]
        
        #expect(bodyData.keys.count == 2)
        
        #expect(bodyData["0"] != nil)
        #expect(bodyData["1"] != nil)

        #expect(bodyData["0"] as? [String:Any] != nil)
        
        let actualInput = bodyData["0"] as! [String:Any]
        
        #expect(actualInput["value1"] != nil)
        #expect(actualInput["value2"] != nil)
        
        #expect(actualInput["value1"] as! Int == 10)
        #expect(actualInput["value2"] as! String == "hello")
        
        #expect(bodyData["1"] as? [String:Any] != nil)
        
        let actualInput2 = bodyData["1"] as! [String:Any]
        
        #expect(actualInput2["value1"] != nil)
        #expect(actualInput2["value2"] != nil)
        
        #expect(actualInput2["value1"] as! Int == 20)
        #expect(actualInput2["value2"] as! String == "world")
    }
    
    @Test func parsesValidTwoSuccessfulBatchExecuteResponses() async throws {
        let serializedResponse = #"[{"result":{"data":{"healthy": true}}},{"result":{}}]"#
        
        let serializedResponseData = serializedResponse.data(using: .utf8)!
        let response = HttpClientResponse(request: nil, status: 200, body: serializedResponseData)
        let httpClient = StubHttpClient(serverUrl: "http://myserver.host", response: response)
        let trpcClient = TrpcClient(httpClient: httpClient)

        let requests: [any TrpcRequestProtocol] = [
            TrpcRequest(type: .mutation, path: "trpc.method1"),
            TrpcRequest(type: .mutation, path: "trpc.method2"),
        ]
        
        let result = try await trpcClient.executeBatch(requests: requests)
        
        let method1Response = try result.get(index: 0, responseType: HealthResponseModel.self)
        
        #expect(method1Response.error == nil)
        #expect(method1Response.result != nil)
        #expect(method1Response.result!.healthy == true)
        
        let method2Response = try result.get(index: 1, responseType: TrpcEmptyResult.self)
        
        #expect(method2Response.error == nil)
        #expect(method2Response.result == nil)
    }
    
    @Test func parsesValidTwoErrorBatchExecuteResponses() async throws {
        let serializedResponse = #"[{"error":{"message":"custom_error_1","code":-32004,"data":{"code":"NOT_FOUND","httpStatus":404,"stack":"some_stack","path":"error"}}},{"error":{"message":"custom_error_2","code":-32004,"data":{"code":"NOT_FOUND","httpStatus":404,"stack":"some_stack","path":"error"}}}]"#
        
        let serializedResponseData = serializedResponse.data(using: .utf8)!
        let response = HttpClientResponse(request: nil, status: 200, body: serializedResponseData)
        let httpClient = StubHttpClient(serverUrl: "http://myserver.host", response: response)
        let trpcClient = TrpcClient(httpClient: httpClient)

        let requests: [any TrpcRequestProtocol] = [
            TrpcRequest(type: .mutation, path: "trpc.method1"),
            TrpcRequest(type: .mutation, path: "trpc.method2"),
        ]
        
        let result = try await trpcClient.executeBatch(requests: requests)
        
        let method1Response = try result.get(index: 0, responseType: HealthResponseModel.self)
        
        #expect(method1Response.error != nil)
        #expect(method1Response.error!.message == "custom_error_1")
        #expect(method1Response.result == nil)
        
        let method2Response = try result.get(index: 1, responseType: TrpcEmptyResult.self)
        
        #expect(method2Response.error != nil)
        #expect(method2Response.error!.message == "custom_error_2")
        #expect(method2Response.result == nil)
    }
    
    @Test func parsesValidMixedBatchExecuteResponses() async throws {
        let serializedResponse = #"[{"result":{"data":{"healthy": true}}},{"error":{"message":"custom_error_2","code":-32004,"data":{"code":"NOT_FOUND","httpStatus":404,"stack":"some_stack","path":"error"}}},{"result":{}}]"#
       
        let serializedResponseData = serializedResponse.data(using: .utf8)!
        let response = HttpClientResponse(request: nil, status: 200, body: serializedResponseData)
        let httpClient = StubHttpClient(serverUrl: "http://myserver.host", response: response)
        let trpcClient = TrpcClient(httpClient: httpClient)

        let requests: [any TrpcRequestProtocol] = [
            TrpcRequest(type: .mutation, path: "trpc.method1"),
            TrpcRequest(type: .mutation, path: "trpc.method2"),
            TrpcRequest(type: .mutation, path: "trpc.method3"),
        ]
        
        let result = try await trpcClient.executeBatch(requests: requests)
        
        let method1Response = try result.get(index: 0, responseType: HealthResponseModel.self)
        
        #expect(method1Response.error == nil)
        #expect(method1Response.result != nil)
        #expect(method1Response.result!.healthy == true)

        let method2Response = try result.get(index: 1, responseType: TrpcEmptyResult.self)
        
        #expect(method2Response.error != nil)
        #expect(method2Response.error!.message == "custom_error_2")
        #expect(method2Response.result == nil)
        
        let method3Response = try result.get(index: 2, responseType: TrpcEmptyResult.self)
        
        #expect(method3Response.error == nil)
        #expect(method3Response.result == nil)
    }
}
