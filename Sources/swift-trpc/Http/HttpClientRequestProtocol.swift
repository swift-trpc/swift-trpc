//
//  HttpClientRequestProtocol.swift
//  swift-trpc
//
//  Created by Artem Tarasenko on 15.11.2024.
//

import Foundation;

internal protocol HttpClientRequestProtocol {
    var path: String { get }
    var method: HttpMethod { get }
    var headers: [String:String] { get }
    var query: [String:String] { get }
    var body: Data? { get }
}
