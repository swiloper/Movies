//
//  StudiosView.swift
//  Movies
//
//  Created by Ihor Myronishyn on 26.09.2023.
//

import SwiftUI
import NukeUI
import Nuke

@MainActor
struct StudiosView: View {
    
    // MARK: - Properties
    
    @Environment(\.layout) private var layout
    @Environment(\.screenSize) private var size
    @Environment(\.horizontalSizeClass) private var horizontal
    
    let items: [Studio]
    
    private var spacing: CGFloat {
        layout.padding / 2
    }
    
    private var width: CGFloat {
        let count: CGFloat = horizontal == .regular ? 3.5 : 1.5
        return (size.width - layout.padding - spacing) / count
    }
    
    private let coefficient: CGFloat = 0.65
    
    // MARK: - Body
    
    var body: some View {
        VStack(alignment: .leading) {
            title
            carusel
        } //: VStack
        .background(Color(uiColor: .systemBackground))
    }
    
    // MARK: - Title
    
    @ViewBuilder
    private var title: some View {
        Text("Studios")
            .font(.system(size: 23, weight: .bold))
            .foregroundStyle(Color.label)
            .padding(EdgeInsets(top: 16, leading: layout.padding, bottom: .zero, trailing: layout.padding))
    }
    
    // MARK: - Carusel
    
    private var carusel: some View {
        ScrollView(.horizontal) {
            LazyHStack(spacing: spacing) {
                ForEach(Array(items.enumerated()), id: \.offset) { index, item in
                    card(item)
                } //: ForEach
            } //: LazyHStack
            .padding(EdgeInsets(top: .zero, leading: layout.padding, bottom: layout.margin, trailing: layout.padding))
            .scrollTargetLayout()
        } //: ScrollView
        .scrollIndicators(.hidden)
        .scrollTargetBehavior(.viewAligned)
    }
    
    // MARK: - Card
    
    private func card(_ studio: Studio) -> some View {
        VStack(alignment: .leading) {
            logo(studio)
            
            Text(studio.name)
                .foregroundStyle(Color.label)
                .lineLimit(1)
        } //: VStack
        .frame(width: width)
    }
    
    // MARK: - Logo
    
    private func logo(_ studio: Studio) -> some View {
        ZStack {
            Color(uiColor: .systemGray4)
            
            if let logo = studio.logo {
                LazyImage(url: URL(string: EndpointPath.image(logo))) { state in
                    ZStack {
                        if let image = state.image {
                            image
                                .resizable()
                                .scaledToFit()
                                .padding()
                        }
                    } //: ZStack
                    .animation(.default, value: state.isLoading)
                } //: LazyImage
                .processors([ImageProcessors.Resize(size: CGSize(width: width, height: width * coefficient))])
            } else {
                let words: [String] = studio.name.split(separator: String.space).map({ String($0) })
                if let first = words.first, let second = words.item(at: 1) {
                    Text(String(first.prefix(1)) + String(second.prefix(1)))
                        .font(.system(size: 80, weight: .medium, design: .rounded))
                        .foregroundStyle(Color.white)
                }
            }
        } //: ZStack
        .frame(width: width, height: width * coefficient)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

// MARK: - Preview

#Preview("Studios") {
    StudiosView(items: [])
}
