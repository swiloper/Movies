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
    @Environment(\.horizontalSizeClass) private var horizontal
    
    @EnvironmentObject private var movies: MoviesViewModel
    
    @StateObject private var model = MovieDetailViewModel()
    
    @State private var offset: CGFloat = .zero
    @State private var opacity: CGFloat = .zero
    @State private var inset: CGFloat = .zero
    
    let id: Int
    
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
        .animation(.smooth, value: model.isLoading)
        .toolbar(.hidden, for: .navigationBar)
        .task {
            await model.detail(for: id)
        }
        .onAppear {
            movies.selected = id
        }
        .onDisappear {
            movies.selected = nil
        }
    }
    
    // MARK: - Content
    
    @ViewBuilder
    private func content(_ movie: Movie) -> some View {
        ScrollView(.vertical) {
            VStack(spacing: .zero) {
                poster(movie)
                overview(movie)
                divider
                studios(movie)
                information(movie)
                Spacer()
            } //: VStack
            .offset {
                offset = $0.minY
            }
        } //: ScrollView
        .scrollIndicators(.hidden)
        .ignoresSafeArea(.container, edges: .top)
        .background(Color.systemGray6.ignoresSafeArea(.container, edges: .bottom))
        .overlay(alignment: .top) {
            header(movie)
        }
    }
    
    // MARK: - Header
    
    @ViewBuilder
    private func header(_ movie: Movie) -> some View {
        HStack {
            Button {
                dismiss()
            } label: {
                Image(systemName: "chevron.left")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(opacity > 0.5 ? Color.accentColor : Color.white)
                    .frame(width: 30, height: 30)
                    .background(blur.opacity(opacity > 0.5 ? .zero : 1))
                    .clipShape(Circle())
                    .animation(.spring, value: opacity > 0.5)
            } //: Button
            .padding(16)
            
            Spacer()
        } //: HStack
        .frame(height: layout.height.header)
        .background {
            let lower = layout.height.slide / 2
            let upper = layout.height.slide - layout.height.header - insets.top
            
            ZStack(alignment: .bottom) {
                Rectangle()
                    .fill(Material.bar)
                    .ignoresSafeArea(.container, edges: .top)
                Rectangle()
                    .foregroundStyle(Color.line)
                    .frame(height: 0.3)
            } //: ZStack
            .overlay {
                ZStack {
                    if opacity >= 1.0 {
                        Text(movie.title)
                            .foregroundStyle(Color.label)
                            .font(.system(size: 17, weight: .semibold))
                            .frame(maxWidth: 200)
                            .lineLimit(1)
                    }
                } //: ZStack
                .animation(.smooth, value: opacity >= 1.0)
            }
            .modifier(OpacityTransitionModifier(offset: $offset, value: $opacity, range: lower...upper))
        }
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
                    .frame(height: insets.top + layout.height.header)
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
                
                Text("\(movie.premiere)  ·  \(movie.duration)")
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
        VStack(spacing: 12) {
            HStack {
                Image(systemName: "star.fill")
                    .font(.system(size: 24, weight: .semibold))
                    .foregroundStyle(Color.yellow)
                
                if let avarage = NumberFormatter.average.string(from: NSNumber(value: movie.rate.average)) {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("\(avarage) average")
                        Text("\(movie.rate.votes) votes")
                    } //: VStack
                    .font(.system(size: 13))
                    .foregroundStyle(Color.gray)
                }
                
                Spacer()
            } //: HStack
            
            Text(movie.overview)
                .foregroundStyle(Color.label)
        } //: VStack
        .padding(EdgeInsets(top: 16, leading: layout.padding, bottom: layout.margin, trailing: layout.padding))
        .background(Color(uiColor: .systemBackground))
    }
    
    // MARK: - Studios
    
    @ViewBuilder
    private func studios(_ movie: Movie) -> some View {
        StudiosView(items: movie.studios)
    }
    
    // MARK: - Information
    
    @ViewBuilder
    private func information(_ movie: Movie) -> some View {
        InformationView(title: "Information", items: [
            ("Status", movie.status),
            ("Released", movie.year),
            ("Run Time", movie.duration),
            ("Region of Origin", movie.countries[.zero].name),
            ("Languages", movie.languages.map({ $0.name }).joined(separator: ", "))
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