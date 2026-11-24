//
//  DiscoveryRouter.swift
//  MoviesM
//
//  Created by Muhammad Fahmi on 24/11/26.
//

import SwiftUI
import TMDBClient

struct DiscoveryInteractor {
    let genre: Genre
    let client: TMDBClient

    func movies(page: Int) async throws -> Page<Movie> {
        try await client.discover(genreID: genre.id, page: page)
    }
}

enum DiscoveryRouter {
    @MainActor static func makeView(genre: Genre, client: TMDBClient) -> some View {
        let interactor = DiscoveryInteractor(genre: genre, client: client)
        return PagedList(presenter: PagedPresenter(fetch: interactor.movies),
                         emptyMessage: "No movies in this genre.") { movie in
            NavigationLink {
                MovieDetailsRouter.makeView(id: movie.id, client: client)
            } label: {
                VStack(alignment: .leading) {
                    Text(movie.title)
                    if let date = movie.releaseDate, !date.isEmpty {
                        Text(date.prefix(4)).font(.caption).foregroundStyle(.secondary)
                    }
                }
            }
        }
        .navigationTitle(genre.name)
    }
}
