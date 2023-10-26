//
//  Category.swift
//  Movies
//
//  Created by Ihor Myronishyn on 05.09.2023.
//

import Foundation

enum Category: Identifiable, Hashable, CaseIterable {
    
    // MARK: - Properties
    
    case playing
    case popular
    case rated
    case upcoming
    case discover(genre: Genre)
    
    static var allCases: [Category] {
        return [.playing, .popular, .rated, .upcoming]
    }
    
    var id: String {
        switch self {
        case .playing:
            return "now_playing"
        case .popular:
            return "popular"
        case .rated:
            return "top_rated"
        case .upcoming:
            return "upcoming"
        case .discover(genre: let genre):
            return String(genre.id)
        }
    }
    
    var title: String {
        switch self {
        case .playing:
            return "Watch Now"
        case .popular:
            return "Popular"
        case .rated:
            return "Top Rated"
        case .upcoming:
            return "Upcoming"
        case .discover(genre: let genre):
            return genre.name
        }
    }
}
