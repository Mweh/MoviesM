//
//  PagedPresenterTests.swift
//  MoviesM
//
//  Created by Muhammad Fahmi on 24/11/26.
//

import Foundation
import Testing
import TMDBClient
@testable import MoviesM

private func page(_ number: Int, ids: [Int]) throws -> Page<Movie> {
    let json: [String: Any] = ["page": number, "totalPages": 2,
                               "results": ids.map { ["id": $0, "title": "Movie"] }]
    return try JSONDecoder().decode(Page<Movie>.self, from: JSONSerialization.data(withJSONObject: json))
}

@Test @MainActor func retryKeepsRowsAndStopsAtLastPage() async {
    var requests: [Int] = []
    let presenter = PagedPresenter<Movie> { number in
        requests.append(number)
        if requests.count == 2 { throw URLError(.timedOut) }
        return try page(number, ids: number == 1 ? [1] : [1, 2])
    }
    await presenter.loadNext()
    await presenter.loadNext()
    #expect(presenter.failed)
    #expect(presenter.items.map(\.id) == [1])
    #expect(presenter.nextPage == 2)
    await presenter.loadNext()
    await presenter.loadNext()
    #expect(requests == [1, 2, 2])
    #expect(presenter.items.map(\.id) == [1, 2])
    #expect(presenter.nextPage == nil)
}

@Test @MainActor func ignoresConcurrentRequests() async {
    var calls = 0
    var pending: CheckedContinuation<Void, Never>?
    let presenter = PagedPresenter<Movie> { number in
        calls += 1
        await withCheckedContinuation { pending = $0 }
        return try page(number, ids: [])
    }
    let first = Task { await presenter.loadNext() }
    while pending == nil { await Task.yield() }
    await presenter.loadNext()
    pending?.resume()
    await first.value
    #expect(calls == 1)
    #expect(presenter.nextPage == nil)
}
