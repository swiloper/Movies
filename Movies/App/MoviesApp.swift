//
//  MoviesApp.swift
//  Movies
//
//  Created by Ihor Myronishyn on 04.09.2023.
//

import SwiftUI

@main
struct MoviesApp: App {
    
    // MARK: - Properties
    
    @State private var movies = MoviesViewModel()
    @State private var genres = GenresViewModel()
    
    // MARK: - Body
    
    var body: some Scene {
        WindowGroup {
            MainView()
                .environment(movies)
                .environment(genres)
        } //: WindowGroup
    }
}
