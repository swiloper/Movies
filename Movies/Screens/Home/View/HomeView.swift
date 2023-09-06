//
//  HomeView.swift
//  Movies
//
//  Created by Ihor Myronishyn on 04.09.2023.
//

import SwiftUI

struct HomeView: View {
    
    // MARK: - Properties
    
    @StateObject private var movies = MoviesViewModel()
    @StateObject private var genres = GenresViewModel()
    
    // MARK: - Body
    
    var body: some View {
        NavigationStack {
            ScrollView(.vertical, showsIndicators: false) {
                LazyVStack(spacing: .zero) {
                    slideshow
                    carusels
                } //: LazyVStack
            } //: ScrollView
            .ignoresSafeArea(.container, edges: .top)
            .task {
                movies.list()
                genres.list()
            }
        } //: NavigationStack
        .environmentObject(movies)
        .environmentObject(genres)
    }
    
    // MARK: - Slideshow
    
    @ViewBuilder
    private var slideshow: some View {
        if let movies = movies.categories[.playing] {
            SlideshowView(items: movies)
        }
    }
    
    // MARK: - Carusels
    
    private var carusels: some View {
        ForEach(Category.allCases.filter({ $0 != .playing })) { key in
            if let movies = movies.categories[key] {
                MovieCaruselView(category: key, items: movies)
            }
        } //: ForEach
    }
}

// MARK: - Preview

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        GeometryReader { proxy in
            HomeView()
            .environment(\.screenSize, proxy.size)
            .environment(\.safeAreaInsets, proxy.safeAreaInsets)
        } //: GeometryReader
    }
}
