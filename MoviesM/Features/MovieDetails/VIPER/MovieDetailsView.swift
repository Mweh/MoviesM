//
//  MovieDetailsView.swift
//  MoviesM
//
//  Created by Muhammad Fahmi on 24/11/26.
//

import SwiftUI
import TMDBClient

struct MovieDetailsView<Reviews: View>: View {
    @State var presenter: MovieDetailsPresenter
    let reviews: () -> Reviews
    @State private var attempt = 0

    var body: some View {
        Group {
            if let movie = presenter.details {
                List {
                    if let path = movie.posterPath {
                        AsyncImage(url: URL(string: "https://image.tmdb.org/t/p/w500" + path)) { image in
                            image.resizable().scaledToFit()
                        } placeholder: {
                            Image(systemName: "film").foregroundStyle(.secondary)
                        }
                        .frame(maxWidth: .infinity, maxHeight: 320)
                        .accessibilityHidden(true)
                    }
                    Section {
                        Text(movie.title).font(.title2.bold())
                        if let date = movie.releaseDate, !date.isEmpty {
                            LabeledContent("Release date", value: date)
                        }
                        if let minutes = movie.runtime, minutes > 0 {
                            LabeledContent("Runtime", value: "\(minutes) min")
                        }
                        if !movie.genres.isEmpty {
                            Text(movie.genres.map(\.name).joined(separator: ", "))
                        }
                    }
                    NavigationLink("User reviews", destination: reviews)
                    Section("Overview") {
                        Text(movie.overview.flatMap { $0.isEmpty ? nil : $0 } ?? "No overview available.")
                    }
                }
            } else if presenter.failed {
                ContentUnavailableView {
                    Label("Movie unavailable", systemImage: "film")
                } actions: {
                    Button("Retry") { attempt += 1 }
                }
            } else {
                ProgressView("Loading movie…")
            }
        }
        .navigationTitle("Movie details")
        .navigationBarTitleDisplayMode(.inline)
        .task(id: attempt) { await presenter.load() }
    }
}
