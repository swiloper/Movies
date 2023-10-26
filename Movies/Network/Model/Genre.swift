//
//  Genre.swift
//  Movies
//
//  Created by Ihor Myronishyn on 05.09.2023.
//

import Foundation

struct Genre: Identifiable, Decodable, Hashable {
    let id: Int
    let name: String
}
