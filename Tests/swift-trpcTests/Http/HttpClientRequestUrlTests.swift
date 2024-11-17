//
//  HttpClientRequestUrl.swift
//  swift-trpc
//
//  Created by Artem Tarasenko on 17.11.2024.
//

import Testing
@testable import swift_trpc

struct HttpClientRequestUrlTests {
    @Test func createsBasicUrlWithoutQuery() async throws {
        let serverUrl = "http://server.host"
        
        let httpRequest = HttpClientRequest(path: "health", method: .post, headers: [:], query: [:])
        let httpRequestUrl = try httpRequest.createURL(serverUrl: serverUrl)
        
        #expect(httpRequestUrl.absoluteString == "http://server.host/health")
    }
}
