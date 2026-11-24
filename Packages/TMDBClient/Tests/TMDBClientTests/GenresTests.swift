//
//  GenresTests.swift
//  MoviesM
//
//  Created by Muhammad Fahmi on 24/11/26.
//

import Foundation
import Testing
@testable import TMDBClient

private func client(status: Int, body: String) -> TMDBClient {
    TMDBClient(token: "test-token") { request in
        #expect(request.url?.path == "/3/genre/movie/list")
        #expect(request.value(forHTTPHeaderField: "Authorization") == "Bearer test-token")
        let response = HTTPURLResponse(url: try #require(request.url), statusCode: status,
                                       httpVersion: nil, headerFields: nil)!
        return (Data(body.utf8), response)
    }
}

@Test func decodesGenres() async throws {
    let genres = try await client(status: 200, body: #"{"genres":[{"id":28,"name":"Action"}]}"#).genres()
    #expect(genres.map(\.id) == [28])
    #expect(genres.first?.name == "Action")
}

@Test func rejectsUnauthorizedRequest() async {
    await #expect(throws: TMDBClient.Failure.unauthorized) {
        try await client(status: 401, body: "").genres()
    }
}

@Test func rejectsMalformedPayload() async {
    await #expect(throws: DecodingError.self) {
        try await client(status: 200, body: "{}").genres()
    }
}

@Test func requiresToken() async {
    await #expect(throws: TMDBClient.Failure.missingToken) {
        try await TMDBClient(token: "").genres()
    }
}
