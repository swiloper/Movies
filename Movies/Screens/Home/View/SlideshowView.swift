//
//  SlideshowView.swift
//  Movies
//
//  Created by Ihor Myronishyn on 05.09.2023.
//

import SwiftUI
import NukeUI
import Nuke

@MainActor
struct SlideshowView: View {
    
    // MARK: - Properties
    
    @Environment(\.layout) private var layout
    @Environment(\.screenSize) private var size
    @Environment(\.safeAreaInsets) private var insets
    @Environment(Navigation.self) private var navigation
    @Environment(MoviesViewModel.self) private var movies
    @Environment(GenresViewModel.self) private var genres
    @Environment(\.horizontalSizeClass) private var horizontal
    
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
    
    // MARK: - Parallax
    
    private func parallax(_ proxy: GeometryProxy) -> CGFloat {
        proxy.frame(in: .global).minY > .zero ? -proxy.frame(in: .global).minY : .zero
    }
    
    // MARK: - Dynamic
    
    private func dynamic(length: CGFloat, proxy: GeometryProxy) -> CGFloat {
        return proxy.frame(in: .global).minY > .zero ? proxy.frame(in: .global).minY + length : length
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
                    if proxy.frame(in: .global).minY > -layout.height.slide {
                        pages(proxy: proxy)
                    }
                }
            } //: ZStack
            .animation(.default, value: items.isEmpty)
            .overlay(alignment: .bottom) {
                control(proxy: proxy)
            }
        } //: GeometryReader
        .frame(height: layout.height.slideshow)
    }
    
    // MARK: - Header
    
    @ViewBuilder
    private func header(proxy: GeometryProxy) -> some View {
        HStack {
            Text("Watch Now")
                .font(.system(size: 35, weight: .bold))
                .foregroundColor(.white)
                .padding(.top, insets.top)
            Spacer()
        } //: HStack
        .padding(layout.padding)
        .background(LinearGradient(colors: [.clear, .black.opacity(0.8)], startPoint: .bottom, endPoint: .top))
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
        .offset(y: parallax(proxy))
        .frame(width: size.width, height: dynamic(length: layout.height.slideshow, proxy: proxy))
        .overlay(alignment: .top) {
            header(proxy: proxy)
        }
        .onAppear {
            if slides.isEmpty {
                setup()
            }
        }
    }
    
    // MARK: - Slide
    
    @ViewBuilder 
    private func slide(_ movie: Movie, proxy: GeometryProxy) -> some View {
        GeometryReader {
            let offset = $0.frame(in: .global).minX
            VStack(spacing: .zero) {
                Button {
                    let selection: Movie = {
                        if movie == slides.first, let last = items.last {
                            return last
                        } else if movie == slides.last, let first = items.first {
                            return first
                        }
                        
                        return movie
                    }()
                    
                    navigation.path.append(.movie(item: selection))
                } label: {
                    image(movie, proxy: proxy)
                        .frame(width: size.width)
                        .offset(x: navigation.path.isEmpty ? -offset / 2 : .zero) // Makes a horizontal parallax effect, about turning pages.
                } //: Button
                .buttonStyle(.plain)
                
                Color.black
                    .frame(height: layout.margin)
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
                .padding(.bottom, layout.margin)
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
        .processors([ImageProcessors.Resize(size: CGSize(width: size.width, height: layout.height.slide))])
        .frame(width: dynamic(length: size.width, proxy: proxy), height: dynamic(length: layout.height.slide, proxy: proxy))
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
            .frame(width: (size.width - layout.padding * 2) / 2)
            .padding(EdgeInsets(top: .zero, leading: layout.padding, bottom: 16, trailing: .zero))
        }
    }
    
    // MARK: - Gradient
    
    private var gradient: some View {
        LinearGradient(colors: [.clear, .black], startPoint: .top, endPoint: .bottom)
            .frame(height: 100)
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
            .frame(width: size.width, height: dynamic(length: layout.height.slideshow, proxy: proxy))
            .overlay(alignment: .bottom) {
                VStack(spacing: .zero) {
                    gradient
                    Color.black
                        .frame(height: layout.margin)
                } //: VStack
            }
            .offset(y: parallax(proxy))
            .overlay(alignment: .top) {
                header(proxy: proxy)
            }
    }
}
