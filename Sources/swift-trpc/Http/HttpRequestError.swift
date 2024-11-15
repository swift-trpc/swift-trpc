//
//  HttpRequestError.swift
//  swift-trpc
//
//  Created by Artem Tarasenko on 15.11.2024.
//

enum HttpRequestError: Error {
    case invalidServerUrl(serverUrl: String)
    case invalidPath(path: String)
    case couldntBuildUrl
    case responseNotHttp
}