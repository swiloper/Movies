//
//  MovieListResponse.swift
//  Movies
//
//  Created by Ihor Myronishyn on 04.09.2023.
//

import Foundation

struct MovieListResponse: Decodable {
    
    // MARK: - Properties
    
    let page: Int
    let results: [Movie]
    let totalPages: Int
    
    // MARK: - Keys
    
    enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
    }
}
