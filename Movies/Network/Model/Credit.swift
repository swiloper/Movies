//
//  Credit.swift
//  Movies
//
//  Created by Ihor Myronishyn on 20.10.2023.
//

import Foundation

struct Credit: Decodable, Equatable {
    let cast: [Cast]
    let crew: [Crew]
}

extension Credit {
    static let empty = Credit(cast: [], crew: [])
}

struct Cast: Decodable, Equatable, Identifiable {
    let id: Int
    let name: String
    let image: String?
    let character: String
    
    // MARK: - Keys
    
    enum CodingKeys: String, CodingKey {
        case id, name, character
        case image = "profile_path"
    }
}

struct Crew: Decodable, Equatable, Identifiable {
    let id: Int
    let job: String
    let name: String
    let image: String?
    
    
    // MARK: - Keys
    
    enum CodingKeys: String, CodingKey {
        case id, job, name
        case image = "profile_path"
    }
}
