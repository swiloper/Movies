//
//  Tab.swift
//  Movies
//
//  Created by Ihor Myronishyn on 25.10.2023.
//

import SwiftUI

enum Tab: Identifiable, CaseIterable {
    case home
    case search
}

extension Tab {
    var id: Tab {
        self
    }
}

@MainActor
extension Tab {
    @ViewBuilder
    var label: some View {
        switch self {
        case .home:
            Label("Watch Now", systemImage: "play.circle.fill")
        case .search:
            Label("Search", systemImage: "magnifyingglass")
        }
    }
    
    @ViewBuilder
    var destination: some View {
        switch self {
        case .home:
            HomeView()
        case .search:
            SearchView()
        }
    }
}
