//
//  Movie.swift
//  MoviesM
//
//  Created by Muhammad Fahmi on 24/11/26.
//

public struct Movie: Decodable, Identifiable, Sendable {
    public let id: Int
    public let title: String
    public let releaseDate: String?
}
