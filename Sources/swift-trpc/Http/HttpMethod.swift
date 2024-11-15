//
//  HttpMethod.swift
//  swift-trpc
//
//  Created by Artem Tarasenko on 15.11.2024.
//

internal enum HttpMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
    case options = "OPTIONS"
}
