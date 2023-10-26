//
//  CategoryView.swift
//  Movies
//
//  Created by Ihor Myronishyn on 26.09.2023.
//

import SwiftUI
import NukeUI
import Nuke

@MainActor
struct CategoryView: View {
    
    // MARK: - Properties
    
    @Environment(\.layout) private var layout
    @Environment(\.screenSize) private var size
    @Environment(Navigation.self) private var navigation
    @Environment(GenresViewModel.self) private var genres
    @Environment(\.horizontalSizeClass) private var horizontal
    
    @State private var model = CategoryViewModel()
    
    let item: Category
    
    private var spacing: CGFloat {
        horizontal == .compact ? 10 : 16
    }
    
    private var columns: [GridItem] {
        [GridItem(.adaptive(minimum: horizontal == .compact ? 160 : 220, maximum: horizontal == .compact ? 190 : 280), spacing: spacing)]
    }
    
    // MARK: - Body
    
    var body: some View {
        ZStack {
            if model.isLoading, model.movies.isEmpty {
                ProgressView()
            } else {
                content
            }
        } //: ZStack
        .navigationTitle(item.title)
        .navigationBarTitleDisplayMode(.large)
        .animation(.smooth, value: model.isLoading)
        .task {
            if model.movies.isEmpty {
                await model.list(category: item)
            }
        }
    }
    
    // MARK: - Content
    
    @ViewBuilder
    private var content: some View {
        if item == .rated, horizontal == .compact {
            list
        } else {
            grid
        }
    }
    
    // MARK: - List
    
    private var list: some View {
        List {
            Section {
                ForEach(Array(model.movies.enumerated()), id: \.offset) { index, movie in
                    let description: String = {
                        var result: String = movie.year
                        
                        if let first = movie.genres.first, let name = genres.name(id: first) {
                            result.append("  ·  \(name)")
                        }
                        
                        return result
                    }()
                    
                    Button {
                        navigation.path.append(.movie(item: movie))
                    } label: {
                        HStack(spacing: 16) {
                            let width: CGFloat = 160
                            
                            image(movie)
                                .frame(width: width, height: width / 25 * 14)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                .border(radius: 10, color: .systemGray6.opacity(0.4), width: 1)
                            
                            Text("\(index.incremented())")
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundColor(.secondary)
                            
                            VStack(alignment: .leading, spacing: 2) {
                                Group {
                                    Text(movie.title)
                                        .font(.footnote)
                                        .foregroundColor(.label)
                                    
                                    Text(description)
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                } //: Group
                                .lineLimit(3)
                            } //: VStack
                            
                            Spacer()
                        } //: HStack
                    } //: Button
                    .listRowInsets(EdgeInsets(top: spacing, leading: layout.padding, bottom: spacing, trailing: layout.padding))
                    .listSectionSeparator(.hidden, edges: .top)
                    .listRowSeparator(movie == model.movies.last ? .hidden : .automatic, edges: .bottom)
                    .task {
                        if movie == model.movies.last, !model.isLoading {
                            await model.list(category: item)
                        }
                    }
                } //: ForEach
            } footer: {
                if model.isLoading, !model.movies.isEmpty {
                    loading
                        .listRowSeparator(.hidden)
                        .frame(maxWidth: .infinity)
                }
            } //: Section
        } //: List
        .listStyle(.plain)
        .scrollIndicators(.hidden)
    }
    
    // MARK: - Grid
    
    private var grid: some View {
        ScrollView(.vertical) {
            LazyVGrid(columns: columns, spacing: spacing) {
                Section {
                    ForEach(Array(model.movies.enumerated()), id: \.offset) { index, movie in
                        Button {
                            navigation.path.append(.movie(item: movie))
                        } label: {
                            tile(index, movie)
                                .task {
                                    if movie == model.movies.last, !model.isLoading {
                                        await model.list(category: item)
                                    }
                                }
                        } //: Button
                    } //: ForEach
                } footer: {
                    if model.isLoading, !model.movies.isEmpty {
                        loading
                    }
                } //: Section
            } //: LazyVGrid
            .padding(.horizontal, layout.padding)
        } //: ScrollView
        .scrollIndicators(.hidden)
    }
    
    // MARK: - Loading
    
    private var loading: some View {
        ProgressView()
            .padding()
            .id(UUID())
    }
    
    // MARK: - Tile
    
    @ViewBuilder
    private func tile(_ index: Int, _ movie: Movie) -> some View {
        if item == .rated, horizontal != .compact {
            let description: String = {
                var result: String = movie.year
                
                if let first = movie.genres.first, let name = genres.name(id: first) {
                    result.append("  ·  \(name)")
                }
                
                return result
            }()
            
            VStack {
                image(movie)
                    .aspectRatio(25 / 14, contentMode: .fit)
                    .background(Color.systemGray6)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .border(radius: 10, color: .systemGray6.opacity(0.4), width: 1)
                
                HStack(spacing: 16) {
                    Text("\(index.incremented())")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.secondary)
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Group {
                            Text(movie.title)
                                .font(.footnote)
                                .foregroundColor(.label)
                            
                            Text(description)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        } //: Group
                        .lineLimit(1)
                    } //: VStack
                    
                    Spacer()
                } //: HStack
            } //: VStack
        } else {
            image(movie)
                .aspectRatio(25 / 14, contentMode: .fit)
                .background(Color.systemGray6)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .border(radius: 10, color: .systemGray6.opacity(0.4), width: 1)
        }
    }
    
    // MARK: - Image
    
    @ViewBuilder
    private func image(_ movie: Movie) -> some View {
        if movie.backdrop.isEmpty {
            ZStack {
                Color(uiColor: .systemGray4)
                Text(movie.title.initials)
                    .font(.system(size: 35, weight: .medium, design: .rounded))
                    .foregroundStyle(Color.white)
            } //: ZStack
        } else {
            LazyImage(url: URL(string: EndpointPath.image(movie.backdrop, compressed: true))) { state in
                ZStack {
                    if let image = state.image {
                        image
                            .resizable()
                            .scaledToFill()
                    } else {
                        Color(uiColor: .systemGray4)
                    }
                } //: ZStack
                .animation(.default, value: state.isLoading)
            } //: LazyImage
            .priority(.veryLow)
        }
    }
}

// MARK: - Preview

#Preview("Category") {
    CategoryView(item: .playing)
}
