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
    @State private var insets = EdgeInsets()
    
    // MARK: - Body
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                NavigationInsetsView(insets: $insets)
                MainView()
            } //: ZStack
            .environment(movies)
            .environment(genres)
            .environment(\.layout.height.header, insets.top)
        } //: WindowGroup
    }
}
