//
//  Navigation.swift
//  Movies
//
//  Created by Ihor Myronishyn on 25.10.2023.
//

import SwiftUI

@Observable final class Navigation {
    var path: [Route] = []
    var tabBarVisibility: Visibility = .visible
}

enum Route: Hashable {
    case category(item: Category)
    case movie(item: Movie)
}
