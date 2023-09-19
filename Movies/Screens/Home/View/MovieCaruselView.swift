//
//  MovieCaruselView.swift
//  Movies
//
//  Created by Ihor Myronishyn on 04.09.2023.
//

import SwiftUI
import Nuke
import NukeUI

@MainActor
struct MovieCaruselView: View {
    
    // MARK: - Properties
    
    @Environment(\.screenSize) private var size
    @Environment(\.horizontalSizeClass) private var horizontal
    @EnvironmentObject private var movies: MoviesViewModel
    @EnvironmentObject private var genres: GenresViewModel
    
    let category: Category
    let items: [Movie]
    
    private let padding: CGFloat = 20
    
    // MARK: - Body
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            header
            list
        } //: VStack
        .padding(EdgeInsets(top: 12, leading: .zero, bottom: 24, trailing: .zero))
        .background(LinearGradient(colors: [.clear, .systemGray6], startPoint: .top, endPoint: .bottom))
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    // MARK: - Header
    
    private var header: some View {
        HStack {
            Text(category.description)
                .font(.system(size: 23))
                .foregroundColor(.label)
            
            Image(systemName: "chevron.right")
                .font(.system(size: 18))
                .foregroundColor(.gray)
        } //: HStack
        .fontWeight(.bold)
        .padding(.horizontal, padding)
    }
    
    // MARK: - List
    
    @ViewBuilder
    private var list: some View {
        let previews: [Movie] = items.isEmpty ? Array(repeating: Movie.placeholder, count: 8) : items
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 10) {
                ForEach(Array(previews.enumerated()), id: \.offset) { index, item in
                    preview(index: index, item: item)
                } //: ForEach
            } //: LazyHStack
            .padding(.horizontal, padding)
            .scrollTargetLayout()
        } //: ScrollView
        .scrollTargetBehavior(.viewAligned)
        .redacted(reason: items.isEmpty ? .placeholder : [])
        .disabled(items.isEmpty)
    }
    
    // MARK: - Preview
    
    @ViewBuilder
    private func preview(index: Int, item: Movie) -> some View {
        let width: CGFloat = {
            let count: CGFloat = horizontal == .compact ? category == .upcoming ? 1 : 2 : category == .upcoming ? 3 : 5
            let spacing: CGFloat = 10
            return (size.width - padding - spacing * count - spacing) / count
        }()
            
        VStack(alignment: .leading) {
            image(item: item, width: width)
            rate(index: index, item: item)
        } //: VStack
        .frame(width: width)
    }
    
    // MARK: - Image
    
    @ViewBuilder
    private func image(item: Movie, width: CGFloat) -> some View {
        let isLarge: Bool = category == .upcoming
        let size = CGSize(width: width, height: isLarge ? width / 2 * 3 : width / 25 * 14)
        let radius: CGFloat = isLarge ? 12 : 8
        let path: String = isLarge ? item.poster : item.backdrop
        
        LazyImage(url: URL(string: EndpointPath.image(path, compressed: !isLarge))) { state in
            ZStack {
                if let image = state.image {
                    image
                        .resizable()
                        .scaledToFill()
                }
            } //: ZStack
            .animation(.default, value: state.isLoading)
        } //: LazyImage
        .processors([ImageProcessors.Resize(size: CGSize(width: size.width, height: size.height))])
        .frame(width: size.width, height: size.height)
        .background(Color.gray.opacity(0.3))
        .overlay(alignment: .bottom) {
            ZStack(alignment: .bottomTrailing) {
                LinearGradient(colors: [.clear, .black.opacity(0.1), .black.opacity(0.3)], startPoint: .top, endPoint: .bottom)
                    .frame(height: 60)
                
                if category == .popular {
                    Image("logo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(.white)
                        .frame(height: 8)
                        .padding(8)
                }
            } //: ZStack
        }
        .cornerRadius(radius)
        .border(radius: radius, color: .systemGray6.opacity(0.4), width: 1)
    }
    
    // MARK: - Rate
    
    @ViewBuilder
    private func rate(index: Int, item: Movie) -> some View {
        if category == .rated {
            let description: String = {
                var result: String = item.year
                
                if let first = item.genres.first, let name = genres.name(id: first) {
                    result.append("  ·  \(name)")
                }
                
                return result
            }()
            
            HStack {
                Text("\(index.incremented())")
                    .font(.system(size: 35, weight: .bold))
                    .foregroundColor(.secondary)
                
                VStack(alignment: .leading, spacing: 2) {
                    Group {
                        Text(item.title)
                            .font(.footnote)
                            .foregroundColor(.label)
                        
                        Text(description)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    } //: Group
                    .lineLimit(1)
                } //: VStack
            } //: HStack
            .frame(height: 30)
        }
    }
}

// MARK: - Preview

struct MovieCaruselView_Previews: PreviewProvider {
    static let genres = GenresViewModel()
    static let category: Category = .rated
    static let height: CGFloat = {
        category == .rated ? 202 : 164
    }()
    
    static var previews: some View {
        GeometryReader { proxy in
            VStack {
                Spacer()
                MovieCaruselView(category: category, items: Movie.preview)
                    .frame(height: height)
                    .environmentObject(MoviesViewModel())
                    .environmentObject(genres)
                    .task {
                        genres.list()
                    }
                Spacer()
            } //: VStack
            .environment(\.screenSize, proxy.size)
        } //: GeometryReader
        .previewLayout(.fixed(width: 393, height: height))
    }
}
