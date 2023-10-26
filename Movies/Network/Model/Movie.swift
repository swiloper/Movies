//
//  Movie.swift
//  Movies
//
//  Created by Ihor Myronishyn on 04.09.2023.
//

import Foundation

struct Country: Decodable, Hashable {
    
    // MARK: - Properties
    
    let locale: String
    let name: String
    
    // MARK: - Keys
    
    enum CodingKeys: String, CodingKey {
        case locale = "iso_3166_1"
        case name
    }
}

struct Language: Decodable, Hashable {
    
    // MARK: - Properties
    
    let name: String
    
    // MARK: - Keys
    
    enum CodingKeys: String, CodingKey {
        case name = "english_name"
    }
}

struct Rate: Decodable, Hashable {
    
    // MARK: - Properties
    
    var average: Double = .zero
    var votes: Int = .zero
}

struct Studio: Identifiable, Decodable, Hashable {
    
    // MARK: - Properties
    
    let id: Int
    let logo: String?
    let name: String
    
    // MARK: - Keys
    
    enum CodingKeys: String, CodingKey {
        case id, name
        case logo = "logo_path"
    }
}

struct Movie: Identifiable, Decodable, Hashable {
    
    // MARK: - Properties
    
    var id: Int
    let backdrop: String
    let poster: String
    let title: String
    let genres: [Int]
    let adult: Bool
    let overview: String
    let release: String
    let runtime: Int
    let homepage: String
    let credits: Credit
    let studios: [Studio]
    let countries: [Country]
    let languages: [Language]
    let status: String
    let tagline: String
    
    var date: Date?
    var year: String = .empty
    var premiere: String = .empty
    var duration: String = .empty
    var rate = Rate()
    
    // MARK: - Keys
    
    enum CodingKeys: String, CodingKey {
        case id, title, adult, overview, runtime, homepage, credits, status, tagline
        case backdrop = "backdrop_path"
        case poster = "poster_path"
        case genres = "genre_ids"
        case release = "release_date"
        case studios = "production_companies"
        case countries = "production_countries"
        case languages = "spoken_languages"
        case average = "vote_average"
        case votes = "vote_count"
    }
    
    // MARK: - Init
    
    init(id: Int, backdrop: String, poster: String, title: String, genres: [Int], adult: Bool, overview: String, release: String, runtime: Int = .zero, homepage: String = .empty, credits: Credit = .empty, studios: [Studio] = [], countries: [Country] = [], languages: [Language] = [], status: String = .empty, tagline: String = .empty, rate: Rate = Rate()) {
        self.id = id
        self.backdrop = backdrop
        self.poster = poster
        self.title = title
        self.genres = genres
        self.adult = adult
        self.overview = overview
        self.release = release
        self.runtime = runtime
        self.homepage = homepage
        self.credits = credits
        self.studios = studios
        self.countries = countries
        self.languages = languages
        self.status = status
        self.tagline = tagline
        self.rate = rate
        date = DateFormatter.default.date(from: release)
        
        if let date {
            year = DateFormatter.year.string(from: date)
            premiere = DateFormatter.short.string(from: date)
        }
        
        duration = time(from: runtime)
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
        runtime = try container.decode(key: .runtime, default: .zero)
        homepage = try container.decode(key: .homepage, default: .empty)
        credits = try container.decode(key: .credits, default: .empty)
        studios = try container.decode(key: .studios, default: [])
        countries = try container.decode(key: .countries, default: [])
        languages = try container.decode(key: .languages, default: [])
        status = try container.decode(key: .status, default: .empty)
        tagline = try container.decode(key: .tagline, default: .empty)
        rate.average = try container.decode(key: .average, default: .zero)
        rate.votes = try container.decode(key: .votes, default: .zero)
        
        date = DateFormatter.default.date(from: release)
        
        if let date {
            year = DateFormatter.year.string(from: date)
            premiere = DateFormatter.short.string(from: date)
        }
        
        duration = time(from: runtime)
    }
    
    // MARK: - Time
    
    private func time(from minutes: Int) -> String {
        let hours = minutes / 60
        let minutes = minutes % 60
        return [hours > .zero ? "\(hours) hr" : .empty, minutes > .zero ? "\(minutes) min" : .empty].filter({ !$0.isEmpty }).joined(separator: .space)
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
