//
//  MovieListResponse.swift
//  Movies
//
//  Created by Ihor Myronishyn on 04.09.2023.
//

import Foundation

struct MovieListResponse: Decodable {
    let page: Int
    let results: [Movie]
}
