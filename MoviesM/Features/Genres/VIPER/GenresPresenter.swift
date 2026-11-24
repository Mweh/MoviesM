//
//  GenresPresenter.swift
//  MoviesM
//
//  Created by Muhammad Fahmi on 24/11/26.
//

import TMDBClient
import Observation

@MainActor @Observable
final class GenresPresenter {
    enum State {
        case loading
        case loaded([Genre])
        case failed(String, canRetry: Bool)
    }

    private(set) var state = State.loading
    private let interactor: GenresInteractor

    init(interactor: GenresInteractor) {
        self.interactor = interactor
    }

    func load() async {
        state = .loading
        do {
            let genres = try await interactor.fetchGenres()
            try Task.checkCancellation()
            state = .loaded(genres)
        } catch TMDBClient.Failure.missingToken {
            state = .failed("Set TMDB_LOCAL_TOKEN in .env.xcconfig, then run the app from Xcode.", canRetry: false)
        } catch TMDBClient.Failure.unauthorized {
            state = .failed("Update your TMDB read token, then relaunch.", canRetry: false)
        } catch {
            guard !Task.isCancelled else { return }
            state = .failed("Couldn’t load movie genres. Please try again.", canRetry: true)
        }
    }
}
