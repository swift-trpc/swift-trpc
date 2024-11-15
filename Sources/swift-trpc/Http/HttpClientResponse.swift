//
//  HttpClientResponse.swift
//  swift-trpc
//
//  Created by Artem Tarasenko on 15.11.2024.
//

import Foundation

struct HttpClientResponse: HttpClientResponseProtocol {
    var request: any HttpClientRequestProtocol
    var status: Int
    var body: Data
}
