//
//  MergeDictionary.swift
//  swift-trpc
//
//  Created by Artem Tarasenko on 15.11.2024.
//

extension Dictionary {
    func merged(with another: [Key: Value]) -> [Key: Value] {
        var result = self

        for (key, value) in another {
            result[key] = value
        }

        return result
    }
}
