//
//  Movie.swift
//  Movies
//
//  Created by Ihor Myronishyn on 04.09.2023.
//

import Foundation

struct Movie: Identifiable, Decodable {
    
    // MARK: - Properties
    
    let id: Int
    let backdrop: String
    let poster: String
    let title: String
    let genres: [Int]
    let adult: Bool
    let overview: String
    let release: String
    
    var date: Date?
    var year: String = .empty
    
    // MARK: - Keys
    
    enum CodingKeys: String, CodingKey {
        case id, title, adult, overview
        case backdrop = "backdrop_path"
        case poster = "poster_path"
        case genres = "genre_ids"
        case release = "release_date"
    }
    
    // MARK: - Init
    
    init(id: Int, backdrop: String, poster: String, title: String, genres: [Int], adult: Bool, overview: String, release: String) {
        self.id = id
        self.backdrop = backdrop
        self.poster = poster
        self.title = title
        self.genres = genres
        self.adult = adult
        self.overview = overview
        self.release = release
        date = DateFormatter.default.date(from: release)
        
        if let date {
            year = DateFormatter.year.string(from: date)
        }
    }
    
    // MARK: - Decoder
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(key: .id, default: .zero)
        backdrop = try container.decode(key: .backdrop, default: .empty)
        poster = try container.decode(key: .poster, default: .empty)
        title = try container.decode(key: .title, default: .empty)
        genres = try container.decode(key: .genres, default: [])
        adult = try container.decode(key: .adult, default: true)
        overview = try container.decode(key: .overview, default: .empty)
        release = try container.decode(key: .release, default: .empty)
        date = DateFormatter.default.date(from: release)
        
        if let date {
            year = DateFormatter.year.string(from: date)
        }
    }
}

// MARK: - Preview

extension Movie {
    static let placeholder = Movie(id: .zero, backdrop: .empty, poster: .empty, title: "Title", genres: [], adult: false, overview: "Overview", release: DateFormatter.default.string(from: Date()))
    
    static let preview = [
        Movie(id: 1, backdrop: "/vT17lPUglrAzjEqMwjPpIDe49ty.jpg", poster: "/eeJjd9JU2Mdj9d7nWRFLWlrcExi.jpg", title: "Mavka: The Forest Song", genres: [16, 12, 10751, 14], adult: false, overview: "Mavka — a Soul of the Forest and its Warden — faces an impossible choice between love and her duty as guardian to the Heart of the Forest, when she falls in love with a human — the talented young musician Lukas.", release: "2023-03-02"),
        Movie(id: 2, backdrop: "/8FQeHmusSN2hk3bICf16x5GFQvT.jpg", poster: "/ym1dxyOk4jFcSl4Q2zmRrA5BEEN.jpg", title: "The Little Mermaid", genres: [12, 10751, 14, 10749], adult: false, overview: "The youngest of King Triton’s daughters, and the most defiant, Ariel longs to find out more about the world beyond the sea, and while visiting the surface, falls for the dashing Prince Eric. With mermaids forbidden to interact with humans, Ariel makes a deal with the evil sea witch, Ursula, which gives her a chance to experience life on land, but ultimately places her life – and her father’s crown – in jeopardy.", release: "2023-05-18"),
        Movie(id: 3, backdrop: "/yF1eOkaYvwiORauRCPWznV9xVvi.jpg", poster: "/rktDFPbfHfUbArZ6OOOKsXcv0Bm.jpg", title: "The Flash", genres: [28, 12, 878], adult: false, overview: "When his attempt to save his family inadvertently alters the future, Barry Allen becomes trapped in a reality in which General Zod has returned and there are no Super Heroes to turn to. In order to save the world that he is in and return to the future that he knows, Barry's only hope is to race for his life. But will making the ultimate sacrifice be enough to reset the universe?", release: "2023-06-13")
    ]
}
