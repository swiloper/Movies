//
//  Layout.swift
//  Movies
//
//  Created by Ihor Myronishyn on 22.09.2023.
//

import Foundation

struct Layout {
    var height = Height()
    let margin: CGFloat = 30
    let padding: CGFloat = 20
}

struct Height {
    var slide: CGFloat = .zero
    var slideshow: CGFloat = .zero
    var header: CGFloat = 44
}
