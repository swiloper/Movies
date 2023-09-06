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
    
    @State private var selection: Int = .zero
    
    var category: Category = .playing
    let items: [Movie]
    
    private let margin: CGFloat = 30
    private let padding: CGFloat = 20
    
    private var height: CGFloat {
        horizontal == .compact ? size.width / 2 * 3 : size.width / 25 * 14
    }
    
    // MARK: - Body
    
    var body: some View {
        TabView(selection: $selection) {
            ForEach(items) { item in
                image(item)
            } //: ForEach
        } //: TabView
        .tabViewStyle(.page)
        .frame(width: size.width, height: height + margin)
        .background {
            Color.gray.opacity(0.3)
                .overlay(alignment: .bottom) {
                    gradient
                }
        }
        .overlay(alignment: .topLeading) {
            header
        }
    }
    
    // MARK: - Header
    
    private var header: some View {
        Text(category.description)
            .font(.system(size: 35, weight: .bold))
            .foregroundColor(.white)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(EdgeInsets(top: insets.top + padding, leading: padding, bottom: .zero, trailing: padding))
            .background(LinearGradient(colors: [.clear, .black.opacity(0.3)], startPoint: .bottom, endPoint: .top))
    }
    
    // MARK: - Image
    
    @ViewBuilder
    private func image(_ movie: Movie) -> some View {
        VStack(spacing: .zero) {
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
            .frame(width: size.width, height: height)
            .background(Color.gray.opacity(0.3))
            .overlay(alignment: .bottom) {
                gradient
            }
            
            Color.black
                .frame(height: margin)
        } //: VStack
        .clipped()
    }
    
    // MARK: - Gradient
    
    private var gradient: some View {
        LinearGradient(colors: [.clear, .black.opacity(0.1), .black.opacity(0.3), .black], startPoint: .top, endPoint: .bottom)
            .frame(height: 160)
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
        } //: GeometryReader
    }
}
