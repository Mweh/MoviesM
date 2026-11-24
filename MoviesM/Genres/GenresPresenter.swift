//
//  GenresPresenter.swift
//  MoviesM
//
//  Created by Muhammad Fahmi on 24/11/26.
//

import Observation

@MainActor @Observable
final class GenresPresenter {
    enum State {
        case loading
        case loaded([Genre])
        case failed(String)
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
        } catch GenresInteractor.Failure.missingToken {
            state = .failed("Set TMDB_READ_TOKEN in the Xcode Run scheme, then relaunch.")
        } catch {
            guard !Task.isCancelled else { return }
            state = .failed("Couldn’t load movie genres. Please try again.")
        }
    }
}
