//
//  GenresInteractor.swift
//  MoviesM
//
//  Created by Muhammad Fahmi on 24/11/26.
//

import Foundation

struct GenresInteractor {
    private struct Response: Decodable {
        let genres: [Genre]
    }

    enum Failure: Error {
        case missingToken
        case rejected
    }

    func fetchGenres() async throws -> [Genre] {
        guard let token = ProcessInfo.processInfo.environment["TMDB_READ_TOKEN"], !token.isEmpty else {
            throw Failure.missingToken
        }
        let url = URL(string: "https://api.themoviedb.org/3/genre/movie/list")!
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let http = response as? HTTPURLResponse, (200..<300).contains(http.statusCode) else {
            throw Failure.rejected
        }
        return try JSONDecoder().decode(Response.self, from: data).genres
    }
}
