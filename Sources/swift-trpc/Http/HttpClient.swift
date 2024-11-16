//
//  HttpClient.swift
//  swift-trpc
//
//  Created by Artem Tarasenko on 15.11.2024.
//

import Foundation

@available(macOS 10.15, *)
internal class HttpClient: HttpClientProtocol {
    var serverUrl: String
    
    private var urlSession: URLSession

    init(serverUrl: String, urlSession: URLSession) {
        self.serverUrl = serverUrl
        self.urlSession = urlSession
    }
    
    func execute(request: any HttpClientRequestProtocol) async throws -> any HttpClientResponseProtocol {
        let url = try request.createURL(serverUrl: self.serverUrl)
        let urlRequest = URLRequest(url: url)
        
        let (data, response) = try await self.executeUrlRequest(request: urlRequest)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw HttpRequestError.responseNotHttp
        }
        
        let status = httpResponse.statusCode
        
        return HttpClientResponse(request: request, status: status, body: data)
    }
    
    @available(iOS 13, macOS 10.15, *)
    private func executeUrlRequest(request: URLRequest) async throws -> (Data, URLResponse) {
        if #available(iOS 15, macOS 12.0, *) {
            let result = try await urlSession.data(for: request)
            return result
        } else {
            return try await withCheckedThrowingContinuation({ continuation in
                urlSession.dataTask(with: request) { data, response, error in
                    if let error {
                        continuation.resume(throwing: error)
                    } else if let data, let response {
                        continuation.resume(returning: (data, response))
                    }
                }
            })
        }
    }
}
