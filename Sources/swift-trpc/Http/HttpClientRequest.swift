//
//  HttpClientRequest.swift
//  swift-trpc
//
//  Created by Artem Tarasenko on 15.11.2024.
//

import Foundation

struct HttpClientRequest: HttpClientRequestProtocol {
    var path: String
    var method: HttpMethod
    var headers: [String : String]
    var query: [String : String]
    var body: Data?
}
