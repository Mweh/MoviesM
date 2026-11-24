//
//  GenresView.swift
//  MoviesM
//
//  Created by Muhammad Fahmi on 24/11/26.
//

import SwiftUI

struct GenresView: View {
    @State var presenter: GenresPresenter
    @State private var attempt = 0

    var body: some View {
        Group {
            switch presenter.state {
            case .loading:
                ProgressView("Loading genres…")
            case .loaded(let genres) where genres.isEmpty:
                ContentUnavailableView("No genres available", systemImage: "film")
            case .loaded(let genres):
                List(genres) { genre in Text(genre.name) }
            case .failed(let message):
                ContentUnavailableView {
                    Label("Genres unavailable", systemImage: "exclamationmark.circle")
                } description: {
                    Text(message)
                } actions: {
                    Button("Retry") { attempt += 1 }
                }
            }
        }
        .navigationTitle("Movie genres")
        .task(id: attempt) { await presenter.load() }
    }
}
