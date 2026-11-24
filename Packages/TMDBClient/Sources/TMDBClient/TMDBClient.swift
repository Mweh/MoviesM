//
//  TMDBClient.swift
//  MoviesM
//
//  Created by Muhammad Fahmi on 24/11/26.
//

import Foundation

public struct TMDBClient: Sendable {
    public enum Failure: Error {
        case missingToken
        case unauthorized
        case invalidResponse
    }

    private let token: String
    private let send: @Sendable (URLRequest) async throws -> (Data, URLResponse)

    public init(token: String) {
        self.init(token: token) { try await URLSession.shared.data(for: $0) }
    }

    init(token: String, send: @escaping @Sendable (URLRequest) async throws -> (Data, URLResponse)) {
        self.token = token
        self.send = send
    }

    public func genres() async throws -> [Genre] {
        struct Response: Decodable {
            let genres: [Genre]
        }

        let response: Response = try await get("genre/movie/list")
        return response.genres
    }

    public func discover(genreID: Int, page: Int) async throws -> Page<Movie> {
        try await get("discover/movie", query: [
            URLQueryItem(name: "with_genres", value: String(genreID)),
            URLQueryItem(name: "page", value: String(page))
        ])
    }

    func get<T: Decodable>(_ path: String, query: [URLQueryItem] = []) async throws -> T {
        guard !token.isEmpty else { throw Failure.missingToken }
        let base = URL(string: "https://api.themoviedb.org/3/")!
        let url = base.appending(path: path).appending(queryItems: query)
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        let (data, response) = try await send(request)
        guard let http = response as? HTTPURLResponse else { throw Failure.invalidResponse }
        if http.statusCode == 401 { throw Failure.unauthorized }
        guard (200..<300).contains(http.statusCode) else { throw Failure.invalidResponse }
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return try decoder.decode(T.self, from: data)
    }
}
