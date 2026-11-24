//
//  ReviewsRouter.swift
//  MoviesM
//
//  Created by Muhammad Fahmi on 24/11/26.
//

import SwiftUI
import TMDBClient

struct ReviewsInteractor {
    let movieID: Int
    let client: TMDBClient

    func reviews(page: Int) async throws -> Page<Review> {
        try await client.reviews(movieID: movieID, page: page)
    }
}

enum ReviewsRouter {
    @MainActor static func makeView(id: Int, client: TMDBClient) -> some View {
        let interactor = ReviewsInteractor(movieID: id, client: client)
        return PagedList(presenter: PagedPresenter(fetch: interactor.reviews),
                         emptyMessage: "No reviews yet.") { review in
            VStack(alignment: .leading, spacing: 8) {
                Text(review.author).font(.headline)
                Text(review.content)
            }
            .padding(.vertical, 4)
        }
        .navigationTitle("Reviews")
    }
}
