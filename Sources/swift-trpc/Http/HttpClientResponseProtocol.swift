//
//  HttpClientResponseProtocol.swift
//  swift-trpc
//
//  Created by Artem Tarasenko on 15.11.2024.
//

import Foundation

internal protocol HttpClientResponseProtocol {
    var request: HttpClientRequestProtocol? { get }
    
    var status: Int { get }
    var body: Data { get }
}
