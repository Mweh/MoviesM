//
//  Review.swift
//  MoviesM
//
//  Created by Muhammad Fahmi on 24/11/26.
//

import Foundation

public struct Review: Identifiable, Decodable, Sendable {
    public let id: String
    public let author: String
    public let content: String
}

extension TMDBClient {
    public func reviews(movieID: Int, page: Int) async throws -> Page<Review> {
        try await get("movie/\(movieID)/reviews", query: [
            URLQueryItem(name: "page", value: String(page))
        ])
    }
}
