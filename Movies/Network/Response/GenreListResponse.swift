//
//  GenreListResponse.swift
//  Movies
//
//  Created by Ihor Myronishyn on 05.09.2023.
//

import Foundation

struct GenreListResponse: Decodable {
    let genres: [Genre]
}
