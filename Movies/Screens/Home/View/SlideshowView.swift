//
//  SlideshowView.swift
//  Movies
//
//  Created by Ihor Myronishyn on 05.09.2023.
//

import SwiftUI
import Nuke
import NukeUI

@MainActor
struct SlideshowView: View {
    
    // MARK: - Properties
    
    @Environment(\.horizontalSizeClass) private var horizontal
    @Environment(\.safeAreaInsets) private var insets
    @Environment(\.screenSize) private var size
    
    @EnvironmentObject private var genres: GenresViewModel
    
    @State private var selection: Int = .zero
    @State private var slides: [Movie] = []
    
    /// Tracks correct current page.
    private var page: Binding<Int> {
        Binding {
            if let first = slides.first, let last = slides.last {
                if selection == first.id {
                    return items.count.decremented()
                } else if selection == last.id {
                    return .zero
                }
            }
            
            if let index = slides.firstIndex(where: { $0.id == selection }) {
                return index.decremented()
            }
            
            return .zero
        } set: {
            if let slide = slides.item(at: $0.incremented()) {
                selection = slide.id
            }
        }
    }
    
    let items: [Movie]
    
    private let margin: CGFloat = 30
    private let padding: CGFloat = 20
    
    private var height: CGFloat {
        horizontal == .compact ? size.width / 2 * 3 : size.width / 25 * 14
    }
    
    // MARK: - Parallax
    
    private func parallax(_ proxy: GeometryProxy) -> CGFloat {
        proxy.frame(in: .global).minY > .zero ? -proxy.frame(in: .global).minY : .zero
    }
    
    // MARK: - Index
    
    private func index(_ of: Movie) -> Int {
        return slides.firstIndex(of: of) ?? .zero
    }
    
    // MARK: - Setup
    
    private func setup() {
        slides = items
        
        if var first = items.first, var last = items.last, items.count > 1 {
            selection = first.id
            
            first.id = UUID().hashValue
            last.id = UUID().hashValue
            
            slides.append(first)
            slides.insert(last, at: .zero)
        }
    }
    
    // MARK: - Body
    
    var body: some View {
        GeometryReader { proxy in
            ZStack {
                if items.isEmpty {
                    empty(proxy: proxy)
                } else {
                    if proxy.frame(in: .global).minY > -height {
                        pages(proxy: proxy)
                    }
                }
            } //: ZStack
            .animation(.default, value: items.isEmpty)
        } //: GeometryReader
        .frame(height: height + margin)
    }
    
    // MARK: - Header
    
    @ViewBuilder
    private func header(proxy: GeometryProxy) -> some View {
        Text("Watch Now")
            .font(.system(size: 35, weight: .bold))
            .foregroundColor(.white)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(EdgeInsets(top: insets.top + padding, leading: padding, bottom: .zero, trailing: padding))
            .background(LinearGradient(colors: [.clear, .black.opacity(0.3)], startPoint: .bottom, endPoint: .top))
            .offset(y: parallax(proxy))
    }
    
    // MARK: - Pages
    
    @ViewBuilder
    private func pages(proxy: GeometryProxy) -> some View {
        TabView(selection: $selection) {
            ForEach(slides) { movie in
                slide(movie, proxy: proxy)
            } //: ForEach
        } //: TabView
        .tabViewStyle(.page(indexDisplayMode: .never)) // Not suitable for displaying pages, as it was necessary to add two more elements to the slide array, for a seamless effect of an infinity slideshow.
        .background(Color.systemGray6)
        .offset(y: parallax(proxy))
        .frame(width: size.width, height: proxy.frame(in: .global).minY > .zero ? proxy.frame(in: .global).minY + height + margin : height + margin)
        .overlay(alignment: .top) {
            header(proxy: proxy)
        }
        .overlay(alignment: .bottom) {
            control(proxy: proxy)
        }
        .onAppear {
            setup()
        }
    }
    
    // MARK: - Slide
    
    @ViewBuilder
    private func slide(_ movie: Movie, proxy: GeometryProxy) -> some View {
        GeometryReader {
            let offset = $0.frame(in: .global).minX
            VStack(spacing: .zero) {
                image(movie, proxy: proxy)
                    .offset(x: -offset / 2) // Makes a horizontal parallax effect, about turning pages.
                Color.black
                    .frame(height: margin)
            } //: VStack
            .overlay(alignment: .bottom) {
                ZStack(alignment: .bottom) {
                    gradient
                    HStack {
                        details(movie)
                        Spacer()
                    } //: HStack
                    .opacity(1.0 - abs(offset) / size.width) // Changes the visibility of the text below the slide, depending on the offset.
                } //: ZStack
                .padding(.bottom, margin)
            }
            .offset(selection == movie.id) { frame in
                let offset = frame.minX - proxy.size.width * CGFloat(index(movie))
                let progress = offset / proxy.size.width
                
                if -progress < 1 {
                    if let slide = slides.item(at: slides.count.decremented()) {
                        selection = slide.id
                    }
                }
                
                if -progress > CGFloat(slides.count.decremented()) {
                    if let slide = slides.item(at: 1) {
                        selection = slide.id
                    }
                }
            }
        } //: GeometryReader
        .clipped()
    }
    
    // MARK: - Image
    
    @ViewBuilder
    private func image(_ movie: Movie, proxy: GeometryProxy) -> some View {
        LazyImage(url: URL(string: EndpointPath.image(horizontal == .compact ? movie.poster : movie.backdrop))) { state in
            ZStack {
                if let image = state.image {
                    image
                        .resizable()
                        .scaledToFill()
                }
            } //: ZStack
            .animation(.default, value: state.isLoading)
        } //: LazyImage
        .processors([ImageProcessors.Resize(size: CGSize(width: size.width, height: height))])
        .frame(width: proxy.frame(in: .global).minY > .zero ? proxy.frame(in: .global).minY + size.width : size.width, height: proxy.frame(in: .global).minY > .zero ? proxy.frame(in: .global).minY + height : height)
        .frame(width: size.width)
    }
    
    // MARK: - Details
    
    @ViewBuilder
    private func details(_ movie: Movie) -> some View {
        if horizontal != .compact {
            VStack(alignment: .leading, spacing: 4) {
                Text(movie.title)
                    .foregroundStyle(.white)
                    .font(.system(size: 22, weight: .bold))
                
                if let first = movie.genres.first, let name = genres.name(id: first) {
                    Text(name)
                        .foregroundStyle(.gray)
                        .font(.system(size: 16, weight: .semibold))
                }
                
                Text(movie.overview)
                    .foregroundStyle(.white)
                    .font(.system(size: 16, weight: .regular))
                    .lineLimit(3)
            } //: VStack
            .frame(width: (size.width - padding * 2) / 2)
            .padding(EdgeInsets(top: .zero, leading: padding, bottom: 16, trailing: .zero))
        }
    }
    
    // MARK: - Gradient
    
    private var gradient: some View {
        LinearGradient(colors: [.clear, .black.opacity(0.1), .black.opacity(0.3), .black], startPoint: .top, endPoint: .bottom)
            .frame(height: 250)
    }
    
    // MARK: - Control
    
    @ViewBuilder
    private func control(proxy: GeometryProxy) -> some View {
        if items.count > 1 {
            PageControl(current: page, amount: items.count)
                .frame(width: 125, height: 8)
                .padding(.bottom, 20)
                .offset(y: parallax(proxy))
        }
    }
    
    // MARK: - Empty
    
    @ViewBuilder
    private func empty(proxy: GeometryProxy) -> some View {
        Color.systemGray6
            .frame(width: size.width, height: proxy.frame(in: .global).minY > .zero ? proxy.frame(in: .global).minY + height + margin : height + margin)
            .offset(y: parallax(proxy))
    }
}

// MARK: - Preview

struct SlideshowView_Previews: PreviewProvider {
    static var previews: some View {
        GeometryReader { proxy in
            ScrollView(.vertical, showsIndicators: false) {
                LazyVStack {
                    SlideshowView(items: Movie.preview)
                    Spacer()
                } //: VStack
            } //: ScrollView
            .ignoresSafeArea(.container, edges: .top)
            .environment(\.screenSize, proxy.size)
            .environment(\.safeAreaInsets, proxy.safeAreaInsets)
            .environmentObject(GenresViewModel())
        } //: GeometryReader
    }
}
