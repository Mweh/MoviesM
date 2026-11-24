//
//  TrailerView.swift
//  MoviesM
//
//  Created by Muhammad Fahmi on 24/11/26.
//

import SafariServices
import SwiftUI

private struct TrailerPlayer: UIViewControllerRepresentable {
    let url: URL

    func makeUIViewController(context: Context) -> SFSafariViewController {
        SFSafariViewController(url: url)
    }

    func updateUIViewController(_ controller: SFSafariViewController, context: Context) {}
}

struct TrailerView: View {
    let fetch: () async throws -> URL?
    @State private var url: URL?
    @State private var message: String?
    @State private var attempt = 0
    @State private var failed = false
    @State private var playing = false

    var body: some View {
        Group {
            if let url {
                Button("Watch trailer", systemImage: "play.circle") { playing = true }
                    .sheet(isPresented: $playing) {
                        TrailerPlayer(url: url).ignoresSafeArea()
                    }
                Link("Open in YouTube", destination: url)
            } else if let message {
                Text(message).foregroundStyle(.secondary)
                if failed {
                    Button("Retry trailer") { attempt += 1 }
                }
            } else {
                ProgressView("Finding trailer…")
            }
        }
        .task(id: attempt) {
            guard url == nil else { return }
            message = nil
            failed = false
            do {
                let result = try await fetch()
                try Task.checkCancellation()
                url = result
                if result == nil { message = "No YouTube trailer available." }
            } catch {
                guard !Task.isCancelled else { return }
                failed = true
                message = "Couldn’t load the trailer."
            }
        }
    }
}
