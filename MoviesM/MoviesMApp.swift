//
//  MoviesMApp.swift
//  MoviesM
//
//  Created by Muhammad Fahmi on 24/11/26.
//

import SwiftUI

@main
struct MoviesMApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationStack { GenresRouter.makeView() }
        }
    }
}
