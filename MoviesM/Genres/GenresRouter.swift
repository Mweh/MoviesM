//
//  GenresRouter.swift
//  MoviesM
//
//  Created by Muhammad Fahmi on 24/11/26.
//

import SwiftUI

enum GenresRouter {
    @MainActor static func makeView() -> GenresView {
        GenresView(presenter: GenresPresenter(interactor: GenresInteractor()))
    }
}
