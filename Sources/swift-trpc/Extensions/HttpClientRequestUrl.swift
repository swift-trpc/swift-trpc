//
//  HttpClientRequestUrl.swift
//  swift-trpc
//
//  Created by Artem Tarasenko on 15.11.2024.
//

import Foundation

internal extension HttpClientRequestProtocol {
    func createURL(serverUrl: String) throws -> URL {
        guard var baseUrl = URLComponents(string: serverUrl) else {
            throw HttpRequestError.invalidServerUrl(serverUrl: serverUrl)
        }
        
        baseUrl.path = self.path
        baseUrl.queryItems = self.query.map({ (key: String, value: String) in
            URLQueryItem(name: key, value: value)
        })
        
        guard let url = baseUrl.url else {
            throw HttpRequestError.couldntBuildUrl
        }
        
        return url
    }
}
