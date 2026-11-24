//
//  PagedPresenter.swift
//  MoviesM
//
//  Created by Muhammad Fahmi on 24/11/26.
//

import Observation
import TMDBClient

@MainActor @Observable
final class PagedPresenter<Item: Decodable & Identifiable & Sendable> {
    private(set) var items: [Item] = []
    private(set) var nextPage: Int? = 1
    private(set) var failed = false
    private var loading = false
    private let fetch: (Int) async throws -> Page<Item>

    init(fetch: @escaping (Int) async throws -> Page<Item>) {
        self.fetch = fetch
    }

    func loadNext() async {
        guard let page = nextPage, !loading else { return }
        loading = true
        failed = false
        defer { loading = false }
        do {
            let response = try await fetch(page)
            try Task.checkCancellation()
            var seen = Set(items.map(\.id))
            items += response.results.filter { seen.insert($0.id).inserted }
            nextPage = page < response.totalPages && !response.results.isEmpty ? page + 1 : nil
        } catch {
            failed = !Task.isCancelled
        }
    }
}
