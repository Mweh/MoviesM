//
//  Page.swift
//  MoviesM
//
//  Created by Muhammad Fahmi on 24/11/26.
//

public struct Page<Item: Decodable & Sendable>: Decodable, Sendable {
    public let page: Int
    public let totalPages: Int
    public let results: [Item]
}
