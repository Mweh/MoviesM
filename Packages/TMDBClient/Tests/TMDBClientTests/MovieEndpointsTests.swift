//
//  MovieEndpointsTests.swift
//  MoviesM
//
//  Created by Muhammad Fahmi on 24/11/26.
//

import Foundation
import Testing
@testable import TMDBClient

private func fixture(_ path: String, query: [String: String] = [:], body: String) -> TMDBClient {
    TMDBClient(token: "test") { request in
        let url = try #require(request.url)
        #expect(url.path == "/3/" + path)
        let items = URLComponents(url: url, resolvingAgainstBaseURL: false)?.queryItems ?? []
        #expect(Dictionary(uniqueKeysWithValues: items.map { ($0.name, $0.value ?? "") }) == query)
        let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!
        return (Data(body.utf8), response)
    }
}

@Test func discoverySendsGenreAndPage() async throws {
    let client = fixture("discover/movie", query: ["with_genres": "28", "page": "2"],
                         body: #"{"page":2,"total_pages":3,"results":[{"id":7,"title":"Seven"}]}"#)
    let page = try await client.discover(genreID: 28, page: 2)
    #expect(page.totalPages == 3)
    #expect(page.results.first?.title == "Seven")
}

@Test func detailsAllowMissingMetadata() async throws {
    let client = fixture("movie/7", body: #"{"title":"Seven","genres":[]}"#)
    let details = try await client.details(movieID: 7)
    #expect(details.runtime == nil)
    #expect(details.posterPath == nil)
}

@Test func emptyReviews() async throws {
    let client = fixture("movie/7/reviews", query: ["page":"1"],
                         body: #"{"page":1,"total_pages":0,"results":[]}"#)
    let page = try await client.reviews(movieID: 7, page: 1)
    #expect(page.results.isEmpty)
}

@Test func prefersOfficialYouTubeTrailer() async throws {
    let client = fixture("movie/7/videos", body: """
    {"results":[
      {"site":"YouTube","type":"Trailer","official":false,"key":"first"},
      {"site":"YouTube","type":"Trailer","official":true,"key":"official"}
    ]}
    """)
    #expect(try await client.trailerURL(movieID: 7)?.query == "v=official")
}

@Test func ignoresNonTrailerVideos() async throws {
    let client = fixture("movie/7/videos", body:
        #"{"results":[{"site":"YouTube","type":"Clip","official":true,"key":"clip"}]}"#)
    #expect(try await client.trailerURL(movieID: 7) == nil)
}
