//
//  SearchView.swift
//  Movies
//
//  Created by Ihor Myronishyn on 09.10.2023.
//

import SwiftUI
import NukeUI
import Nuke

@MainActor
struct SearchView: View {
    
    // MARK: - Properties
    
    @Environment(\.layout) private var layout
    @Environment(Navigation.self) private var navigation
    @Environment(GenresViewModel.self) private var genres
    @Environment(\.horizontalSizeClass) private var horizontal
    
    @StateObject private var search = SearchViewModel()
    
    private var spacing: CGFloat {
        horizontal == .compact ? 10 : 16
    }
    
    private var columns: [GridItem] {
        [GridItem(.adaptive(minimum: horizontal == .compact ? 160 : 220, maximum: horizontal == .compact ? 190 : 280), spacing: spacing)]
    }
    
    // MARK: - Body
    
    var body: some View {
        @Bindable var navigation = navigation
        
        NavigationStack(path: $navigation.path) {
            ZStack {
                if genres.items.isEmpty {
                    ProgressView()
                } else {
                    content
                }
            } //: ZStack
            .navigationTitle("Search")
            .navigationBarTitleDisplayMode(.large)
            .searchable(text: $search.keyword, placement: .toolbar, prompt: "Movies")
            .onChange(of: search.keyword) {
                if $1.isEmpty {
                    search.reset()
                }
            }
            .onReceive(search.$keyword.removeDuplicates().debounce(for: .seconds(0.8), scheduler: RunLoop.main)) {
                if !$0.isEmpty, search.lastQuery != $0 {
                    Task {
                        await search.list()
                    } //: Task
                }
            }
            .ignoresSafeArea(.keyboard, edges: .bottom)
            .navigationDestination(for: Route.self) { route in
                switch route {
                case .category(let value):
                    CategoryView(item: value)
                case .movie(let value):
                    MovieDetailView(item: value)
                }
            }
        } //: NavigationStack
    }
    
    // MARK: - Content
    
    @ViewBuilder
    private var content: some View {
        if search.lastQuery.isEmpty {
             grid
        } else {
            if search.results.isEmpty {
                empty
            } else {
                list
            }
        }
    }
    
    // MARK: - List
    
    private var list: some View {
        List {
            ForEach(search.results) { result in
                Button {
                    navigation.path.append(.movie(item: result))
                } label: {
                    HStack(spacing: 12) {
                        let height: CGFloat = 80
                        
                        LazyImage(url: URL(string: EndpointPath.image(result.backdrop, compressed: true))) { state in
                            ZStack {
                                if let image = state.image {
                                    image
                                        .resizable()
                                        .scaledToFill()
                                } else {
                                    Color.systemGray6
                                }
                            } //: ZStack
                            .animation(.default, value: state.isLoading)
                        } //: LazyImage
                        .priority(.veryLow)
                        .frame(width: height * 25 / 14, height: height)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .border(radius: 8, color: .systemGray6.opacity(0.4), width: 1)
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text(result.title)
                                .font(.system(size: 17, weight: .medium))
                                .foregroundStyle(Color.label)
                                .lineLimit(2)
                            
                            Text(result.year)
                                .font(.system(size: 15))
                                .foregroundStyle(Color.secondary)
                        } //: VStack
                        
                        Spacer()
                    } //: HStack
                    .onAppear {
                        if result == search.results.last {
                            Task {
                                await search.list()
                            } //: Task
                        }
                    }
                } //: Button
            } //: ForEach
            .listSectionSeparator(.hidden)
        } //: List
        .listStyle(.plain)
        .scrollIndicators(.hidden)
    }
    
    // MARK: - Grid
    
    private var grid: some View {
        ScrollView(.vertical) {
            LazyVGrid(columns: columns) {
                ForEach(genres.items) { genre in
                    if let image = UIImage(named: genre.name.lowercased()) {
                        Button {
                            navigation.path.append(.category(item: .discover(genre: genre)))
                        } label: {
                            Image(uiImage: image)
                                .resizable()
                                .aspectRatio(17 / 10, contentMode: .fill)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                                .border(radius: 12, color: .systemGray6.opacity(0.4), width: 1)
                        } //: Button
                    }
                } //: ForEach
            } //: LazyVGrid
            .padding(.horizontal, layout.padding)
        } //: ScrollView
    }
    
    // MARK: - Empty
    
    private var empty: some View {
        ContentUnavailableView.search(text: search.lastQuery)
    }
}

// MARK: - Preview

#Preview("Search") {
    SearchView()
}
