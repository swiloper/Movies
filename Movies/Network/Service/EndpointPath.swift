//
//  EndpointPath.swift
//  Movies
//
//  Created by Ihor Myronishyn on 04.09.2023.
//

import Foundation

enum EndpointPath {
    
    // MARK: - Token
    
    static var token: String {
        unwrapped(Bundle.main.token)
    }
    
    // MARK: - Base
    
    static var base: String {
        var components = URLComponents()
        components.scheme = "https"
        components.host = Bundle.main.base
        return unwrapped(components.string)
    }

    // MARK: - Image
    
    static func image(_ path: String, compressed: Bool = false) -> String {
        let quality: String = compressed ? "w500" : "original"
        var components = URLComponents()
        components.scheme = "https"
        components.host = "image.tmdb.org"
        components.path = "/t/p/\(quality)\(path)"
        return unwrapped(components.string)
    }
    
    // MARK: - Genres
    
    static let genres: String = "/3/genre/movie/list"
    
    // MARK: - Category
    
    static func category(_ path: String) -> String {
        return "/3/movie/\(path)"
    }
}
