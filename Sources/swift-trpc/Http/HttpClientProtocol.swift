//
//  HttpClientProtocol.swift
//  swift-trpc
//
//  Created by Artem Tarasenko on 15.11.2024.
//

@available(iOS 13, macOS 10.15, *)
internal protocol HttpClientProtocol {
    var serverUrl: String { get }

    @available(iOS 13, macOS 10.15, *)
    func execute(request: HttpClientRequestProtocol) async throws -> HttpClientResponseProtocol
}
