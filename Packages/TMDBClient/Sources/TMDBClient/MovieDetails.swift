//
//  MovieDetails.swift
//  MoviesM
//
//  Created by Muhammad Fahmi on 24/11/26.
//

public struct MovieDetails: Decodable, Sendable {
    public let title: String
    public let overview: String?
    public let releaseDate: String?
    public let runtime: Int?
    public let posterPath: String?
    public let genres: [Genre]
}

extension TMDBClient {
    public func details(movieID: Int) async throws -> MovieDetails {
        try await get("movie/\(movieID)")
    }
}
