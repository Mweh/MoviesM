//
//  MovieDetailsPresenter.swift
//  MoviesM
//
//  Created by Muhammad Fahmi on 24/11/26.
//

import Observation
import TMDBClient

struct MovieDetailsInteractor {
    let movieID: Int
    let client: TMDBClient

    func fetch() async throws -> MovieDetails {
        try await client.details(movieID: movieID)
    }
}

@MainActor @Observable
final class MovieDetailsPresenter {
    private(set) var details: MovieDetails?
    private(set) var failed = false
    private let interactor: MovieDetailsInteractor

    init(interactor: MovieDetailsInteractor) {
        self.interactor = interactor
    }

    func load() async {
        guard details == nil else { return }
        failed = false
        do {
            let result = try await interactor.fetch()
            try Task.checkCancellation()
            details = result
        } catch {
            failed = !Task.isCancelled
        }
    }
}
