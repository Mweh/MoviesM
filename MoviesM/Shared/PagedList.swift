//
//  PagedList.swift
//  MoviesM
//
//  Created by Muhammad Fahmi on 24/11/26.
//

import SwiftUI

struct PagedList<Item: Decodable & Identifiable & Sendable, Row: View>: View {
    @State var presenter: PagedPresenter<Item>
    let emptyMessage: String
    @ViewBuilder let row: (Item) -> Row
    @State private var attempt = 0

    var body: some View {
        List {
            ForEach(presenter.items, content: row)
            if let page = presenter.nextPage {
                VStack {
                    if presenter.failed {
                        Text("Couldn’t load this page.")
                        Button("Retry") { attempt += 1 }
                    } else {
                        ProgressView("Loading…")
                    }
                }
                .frame(maxWidth: .infinity)
                .id(page)
                .task(id: attempt) {
                    await presenter.loadNext()
                }
            } else if presenter.items.isEmpty {
                Text(emptyMessage)
                    .foregroundStyle(.secondary)
            }
        }
    }
}
