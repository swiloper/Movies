//
//  Navigation.swift
//  Movies
//
//  Created by Ihor Myronishyn on 25.10.2023.
//

import Foundation

@Observable final class Navigation {
    var path: [Route] = []
}

enum Route: Hashable {
    case category(item: Category)
    case movie(item: Movie)
}
