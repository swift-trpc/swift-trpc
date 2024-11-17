//
//  TrpcBatchRequest.swift
//  swift-trpc
//
//  Created by Artem Tarasenko on 17.11.2024.
//

import Foundation

internal struct TrpcBatchRequest: HttpClientRequestProtocol {
    var path: String
    var method: HttpMethod
    var headers: [String : String]
    var query: [String : String]
    var body: Data?
    
    init(requests: [any TrpcRequestProtocol], trpcClient: any TrpcClientProtocol) throws {
        if requests.count == 0 {
            throw TrpcError.batchRequestEmpty
        }
        
        let requestType = requests[0].type
        
        let requestTypesDiffer = requests.reduce(false) { partialResult, request in
            partialResult || request.type != requestType
        }
        
        if requestTypesDiffer {
            throw TrpcError.batchRequestTypesDiffer
        }
        
        self.path = requests.map({ $0.path }).joined(separator: ",")
        self.headers = requests.reduce(trpcClient.baseHeaders) { partialResult, request in
            return partialResult.merged(with: request.headers)
        }
        
        var encodedInputs: [String:Any] = [:]
        
        for (i, request) in requests.enumerated() {
            if request.hasInputData, let inputData = try request.serializeInput() {
                let decoded = try JSONSerialization.jsonObject(with: inputData)
                encodedInputs[String(i)] = decoded
            }
        }
        
        let encodedInputsData = try JSONSerialization.data(withJSONObject: encodedInputs)

        self.query = [:]
        
        if requestType == .mutation {
            self.method = .post
            self.body = encodedInputsData
        } else {
            self.method = .get
            self.body = nil
            self.query["input"] = String(decoding: encodedInputsData, as: UTF8.self)
        }
        
        self.query["batch"] = "1"
    }
}
