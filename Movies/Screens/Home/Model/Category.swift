//
//  Category.swift
//  Movies
//
//  Created by Ihor Myronishyn on 05.09.2023.
//

import Foundation

enum Category: String, Identifiable, CaseIterable {
    
    // MARK: - Properties
    
    case playing = "now_playing"
    case popular
    case rated = "top_rated"
    case upcoming
    
    var id: String {
        self.rawValue
    }
    
    var description: String {
        switch self {
        case .playing:
            return "Watch Now"
        case .popular:
            return "Popular"
        case .rated:
            return "Top Rated"
        case .upcoming:
            return "Upcoming"
        }
    }
}
