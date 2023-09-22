//
//  HomeView.swift
//  Movies
//
//  Created by Ihor Myronishyn on 04.09.2023.
//

import SwiftUI

struct HomeView: View {
    
    // MARK: - Properties
    
    @Environment(\.layout) private var layout
    
    @StateObject private var movies = MoviesViewModel()
    @StateObject private var genres = GenresViewModel()
    
    @State private var offset: CGFloat = .zero
    
    // MARK: - Body
    
    var body: some View {
        NavigationStack {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: .zero) {
                    slideshow
                    carusels
                } //: VStack
                .offset {
                    offset = $0.minY
                }
            } //: ScrollView
            .ignoresSafeArea(.container, edges: .top)
            .task {
                movies.list()
                genres.list()
            }
            .overlay(alignment: .top) {
                HeaderView(offset: $offset)
            }
        } //: NavigationStack
        .environmentObject(movies)
        .environmentObject(genres)
        .environment(\.layout.height.slideshow, layout.height.slide + layout.margin)
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
