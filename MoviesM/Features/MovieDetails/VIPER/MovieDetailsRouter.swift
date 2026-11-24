//
//  MovieDetailsRouter.swift
//  MoviesM
//
//  Created by Muhammad Fahmi on 24/11/26.
//

import SwiftUI
import TMDBClient

enum MovieDetailsRouter {
    @MainActor static func makeView(id: Int, client: TMDBClient) -> some View {
        let interactor = MovieDetailsInteractor(movieID: id, client: client)
        return MovieDetailsView(presenter: MovieDetailsPresenter(interactor: interactor)) {
            ReviewsRouter.makeView(id: id, client: client)
        }
    }
}
