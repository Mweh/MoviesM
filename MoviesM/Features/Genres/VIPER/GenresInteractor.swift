//
//  GenresInteractor.swift
//  MoviesM
//
//  Created by Muhammad Fahmi on 24/11/26.
//

import TMDBClient

struct GenresInteractor {
    let client: TMDBClient

    func fetchGenres() async throws -> [Genre] {
        try await client.genres()
    }
}
