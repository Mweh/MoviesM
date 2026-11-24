//
//  GenresRouter.swift
//  MoviesM
//
//  Created by Muhammad Fahmi on 24/11/26.
//

import TMDBClient
import SwiftUI

enum GenresRouter {
    @MainActor static func makeView(client: TMDBClient) -> GenresView {
        GenresView(presenter: GenresPresenter(interactor: GenresInteractor(client: client)))
    }
}
