//
//  MovieDetailView.swift
//  Movies
//
//  Created by Ihor Myronishyn on 22.09.2023.
//

import SwiftUI
import NukeUI
import Nuke

@MainActor
struct MovieDetailView: View {
    
    // MARK: - Properties
    
    @Environment(\.layout) private var layout
    @Environment(\.dismiss) private var dismiss
    @Environment(\.screenSize) private var size
    @Environment(\.safeAreaInsets) private var insets
    @Environment(MoviesViewModel.self) private var movies
    @Environment(\.horizontalSizeClass) private var horizontal
    
    @State private var model = MovieDetailViewModel()
    @State private var offset: CGFloat = .zero
    @State private var opacity: CGFloat = .zero
    @State private var inset: CGFloat = .zero
    
    let item: Movie
    
    // MARK: - Parallax
    
    private func parallax(_ proxy: GeometryProxy) -> CGFloat {
        proxy.frame(in: .global).minY > .zero ? -proxy.frame(in: .global).minY : .zero
    }
    
    // MARK: - Dynamic
    
    private func dynamic(length: CGFloat, proxy: GeometryProxy) -> CGFloat {
        proxy.frame(in: .global).minY > .zero ? proxy.frame(in: .global).minY + length : length
    }
    
    // MARK: - Body
    
    var body: some View {
        ZStack {
            if model.isLoading {
                ProgressView()
            } else if let movie = model.movie {
                content(movie)
            }
        } //: ZStack
        .navigationTitle(String.empty)
        .toolbarTitleDisplayMode(.inline)
        .toolbarBackground(.hidden, for: .navigationBar)
        .navigationBarBackButtonHidden()
        .toolbar {
            toolbar
        }
        .ignoresSafeArea(.container, edges: .top)
        .animation(.smooth, value: model.isLoading)
        .task {
            if model.movie == nil {
                await model.detail(for: item.id)
            }
        }
    }
    
    // MARK: - Content
    
    @ViewBuilder
    private func content(_ movie: Movie) -> some View {
        ScrollView(.vertical) {
            VStack(spacing: .zero) {
                poster(movie)
                overview(movie)
                
                if !movie.credits.cast.isEmpty {
                    if !movie.overview.isEmpty {
                        divider
                    }
                    
                    cast(movie)
                }
                
                if !movie.credits.crew.isEmpty {
                    if !movie.overview.isEmpty || !movie.credits.cast.isEmpty {
                        divider
                    }
                    
                    crew(movie)
                }
                
                if !movie.studios.isEmpty {
                    if !movie.overview.isEmpty || !movie.credits.cast.isEmpty || !movie.credits.crew.isEmpty {
                        divider
                    }
                    
                    studios(movie)
                }
                
                information(movie)
                Spacer()
            } //: VStack
            .offset {
                offset = $0.minY
            }
        } //: ScrollView
        .scrollIndicators(.hidden)
        .overlay(alignment: .top) {
            header(movie)
        }
        .ignoresSafeArea(.container, edges: .top)
        .background(Color.systemGray6.ignoresSafeArea(.container, edges: .bottom))
    }
    
    // MARK: - Header
    
    @ViewBuilder
    private func header(_ movie: Movie) -> some View {
        Color.clear
            .frame(height: layout.height.header)
            .background {
                let lower = layout.height.slide / 2
                let upper = layout.height.slide - layout.height.header
                
                ZStack(alignment: .bottom) {
                    Rectangle()
                        .fill(Material.bar)
                        .ignoresSafeArea(.container, edges: .top)
                    Rectangle()
                        .foregroundStyle(Color.line)
                        .frame(height: 0.3)
                } //: ZStack
                .modifier(OpacityTransitionModifier(offset: $offset, value: $opacity, range: lower...upper))
                .ignoresSafeArea(.container, edges: .top)
            }
    }
    
    // MARK: - Toolbar
    
    @ToolbarContentBuilder
    private var toolbar: some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            Button {
                dismiss()
            } label: {
                Image(systemName: "chevron.left")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(opacity > 0.5 ? Color.accentColor : Color.white)
                    .frame(width: 30, height: 30)
                    .background(blur.opacity(opacity > 0.5 ? .zero : 1))
                    .clipShape(Circle())
                    .animation(.spring, value: opacity > 0.5)
            } //: Button
            .buttonStyle(.plain)
        } //: ToolbarItem
        
        ToolbarItemGroup(placement: .principal) {
            if let movie = model.movie {
                Text(movie.title)
                    .foregroundStyle(Color.label)
                    .font(.system(size: 17, weight: .semibold))
                    .frame(maxWidth: 200)
                    .lineLimit(1)
                    .opacity(opacity >= 1 ? 1 : .zero)
                    .animation(.default, value: opacity)
            }
        } //: ToolbarItemGroup
    }

    // MARK: - Poster
    
    @ViewBuilder
    private func poster(_ movie: Movie) -> some View {
        GeometryReader { proxy in
            LazyImage(url: URL(string: EndpointPath.image(horizontal == .compact ? movie.poster : movie.backdrop))) { state in
                ZStack {
                    if let image = state.image {
                        if -offset > layout.height.slide + layout.height.header {
                            Color.systemGray6
                        } else {
                            image
                                .resizable()
                                .scaledToFill()
                        }
                    }
                } //: ZStack
                .animation(.default, value: state.isLoading)
            } //: LazyImage
            .processors([ImageProcessors.Resize(size: CGSize(width: size.width, height: layout.height.slide))])
            .offset(y: proxy.frame(in: .global).minY < .zero ? -proxy.frame(in: .global).minY / 1.25 : .zero)
            .frame(width: dynamic(length: size.width, proxy: proxy), height: dynamic(length: layout.height.slide, proxy: proxy))
            .frame(width: size.width)
            .overlay(alignment: .top) {
                LinearGradient(colors: [.clear, .black.opacity(0.8)], startPoint: .bottom, endPoint: .top)
                    .frame(height: layout.height.header)
                    .offset(y: proxy.frame(in: .global).minY < .zero ? -proxy.frame(in: .global).minY / 1.25 : .zero)
            }
            .overlay(alignment: .bottom) {
                description(movie)
            }
            .overlay {
                Color(uiColor: .systemBackground)
                    .opacity(opacity)
            }
            .offset(y: parallax(proxy))
        } //: GeometryReader
        .frame(height: layout.height.slide)
    }
    
    // MARK: - Description
    
    @ViewBuilder
    private func description(_ movie: Movie) -> some View {
        VStack {
            VStack(spacing: 4) {
                Text(movie.title)
                    .font(.system(size: 20, weight: .semibold))
                    .multilineTextAlignment(.center)
                    .foregroundStyle(Color.white)
                    .background {
                        GeometryReader {
                            let size = $0.size
                            Color.clear
                                .onAppear {
                                    inset = size.height
                                }
                        } //: GeometryReader
                    }
                
                let separator: String = !movie.premiere.isEmpty && !movie.duration.isEmpty ? "  ·  " : .empty
                Text("\(movie.premiere + separator + movie.duration)")
                    .font(.system(size: 13))
                    .foregroundStyle(Color.white.opacity(0.6))
            } //: VStack
            
            if let destination = URL(string: movie.homepage) {
                Link(destination: destination) {
                    Text("Homepage")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundStyle(Color.white)
                        .padding(EdgeInsets(top: 12, leading: 32, bottom: 12, trailing: 32))
                        .background(.ultraThinMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                } //: Link
            }
            
            if !movie.tagline.isEmpty {
                Text(movie.tagline)
                    .font(.system(size: 16))
                    .multilineTextAlignment(.center)
                    .foregroundStyle(Color.white)
                    .padding(.top, 2)
            }
        } //: VStack
        .padding(layout.padding)
        .frame(maxWidth: .infinity)
        .background {
            blur
                .mask {
                    VStack(spacing: .zero) {
                        LinearGradient(gradient: Gradient(colors: [.clear, .black]), startPoint: .top, endPoint: .bottom)
                            .frame(height: layout.padding + inset / 2)
                        Color.black
                    } //: VStack
                }
                .blur(radius: 8)
                .padding(-layout.padding)
        }
    }
    
    // MARK: - Overview
    
    @ViewBuilder
    private func overview(_ movie: Movie) -> some View {
        let avarage = NumberFormatter.average.string(from: NSNumber(value: movie.rate.average))
        
        if avarage != nil && movie.rate.votes > .zero || !movie.overview.isEmpty {
            VStack(alignment: .leading, spacing: 12) {
                if let avarage, movie.rate.votes > .zero {
                    HStack {
                        Image(systemName: "star.fill")
                            .font(.system(size: 24, weight: .semibold))
                            .foregroundStyle(Color.yellow)
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text("\(avarage) average")
                            Text("\(movie.rate.votes) votes")
                        } //: VStack
                        .font(.system(size: 13))
                        .foregroundStyle(Color.gray)
                    } //: HStack
                }
                
                if !movie.overview.isEmpty {
                    Text(movie.overview)
                        .foregroundStyle(Color.label)
                }
            } //: VStack
            .padding(EdgeInsets(top: 16, leading: layout.padding, bottom: layout.margin, trailing: layout.padding))
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color(uiColor: .systemBackground))
        }
    }
    
    // MARK: - Cast
    
    private func cast(_ movie: Movie) -> some View {
        HeadlinedCaruselView(title: "Cast") {
            ForEach(Array(movie.credits.cast.enumerated()), id: \.offset) { index, cast in
                PersonView(item: .init(id: cast.id, image: cast.image, name: cast.name, description: cast.character))
            } //: ForEach
        } //: DetailCaruselView
    }
    
    // MARK: - Crew
    
    private func crew(_ movie: Movie) -> some View {
        HeadlinedCaruselView(title: "Crew") {
            ForEach(Array(movie.credits.crew.enumerated()), id: \.offset) { index, crew in
                PersonView(item: .init(id: crew.id, image: crew.image, name: crew.name, description: crew.job))
            } //: ForEach
        } //: DetailCaruselView
    }
    
    // MARK: - Studios
    
    private func studios(_ movie: Movie) -> some View {
        HeadlinedCaruselView(title: "Studios") {
            ForEach(Array(movie.studios.enumerated()), id: \.offset) { index, studio in
                StudioView(item: studio)
            } //: ForEach
        } //: DetailCaruselView
    }
    
    // MARK: - Information
    
    @ViewBuilder
    private func information(_ movie: Movie) -> some View {
        let countries = movie.countries.map({ $0.name }).joined(separator: ", ")
        let languages = movie.languages.map({ $0.name }).joined(separator: ", ")
        
        InformationView(title: "Information", items: [
            ("Status", movie.status),
            ("Released", movie.year),
            ("Run Time", movie.duration.isEmpty ? "–" : movie.duration),
            ("Region of Origin", countries.isEmpty ? "–" : countries),
            ("Languages", languages.isEmpty ? "–" : languages)
        ])
    }
    
    // MARK: - Divider
    
    private var divider: some View {
        HStack {
            Capsule()
                .foregroundStyle(Color.systemGray6)
                .frame(height: 1)
                .padding(.horizontal, layout.padding)
        } //: HStack
        .frame(maxWidth: .infinity)
        .background(Color(uiColor: .systemBackground))
    }
    
    // MARK: - Blur
    
    private var blur: some View {
        ZStack {
            Rectangle()
                .fill(Material.ultraThinMaterial)
            Color.black.opacity(0.25)
        } //: ZStack
    }
}
