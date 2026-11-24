//
//  Genre.swift
//  MoviesM
//
//  Created by Muhammad Fahmi on 24/11/26.
//

public struct Genre: Decodable, Identifiable, Sendable {
    public let id: Int
    public let name: String
}
