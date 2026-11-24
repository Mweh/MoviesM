//
//  MoviesMApp.swift
//  MoviesM
//
//  Created by Muhammad Fahmi on 24/11/26.
//

import TMDBClient
import SwiftUI

@main
struct MoviesMApp: App {
    private let client = TMDBClient(token: ProcessInfo.processInfo.environment["TMDB_READ_TOKEN"] ?? "")

    var body: some Scene {
        WindowGroup {
            NavigationStack { GenresRouter.makeView(client: client) }
        }
    }
}
