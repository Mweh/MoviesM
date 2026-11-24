//
//  Trailer.swift
//  MoviesM
//
//  Created by Muhammad Fahmi on 24/11/26.
//

import Foundation

extension TMDBClient {
    public func trailerURL(movieID: Int) async throws -> URL? {
        struct Video: Decodable {
            let site: String
            let type: String
            let key: String
            let official: Bool
        }
        struct Response: Decodable {
            let results: [Video]
        }

        let response: Response = try await get("movie/\(movieID)/videos")
        let trailers = response.results.filter { $0.site == "YouTube" && $0.type == "Trailer" && !$0.key.isEmpty }
        guard let video = trailers.first(where: \.official) ?? trailers.first else { return nil }
        return URL(string: "https://www.youtube.com/watch")!.appending(queryItems: [
            URLQueryItem(name: "v", value: video.key)
        ])
    }
}
