//
//  HeadlinedCaruselView.swift
//  Movies
//
//  Created by Ihor Myronishyn on 20.10.2023.
//

import SwiftUI

struct HeadlinedCaruselView<Content: View>: View {
    
    // MARK: - Properties
    
    @Environment(\.layout) private var layout
    
    let title: String
    let content: Content
    
    var spacing: CGFloat {
        layout.padding / 2
    }
    
    // MARK: - Init
    
    init(title: String, @ViewBuilder content: @escaping () -> Content) {
        self.title = title
        self.content = content()
    }
    
    // MARK: - Body
    
    var body: some View {
        VStack(alignment: .leading) {
            headline
            list
        } //: VStack
        .background(Color(uiColor: .systemBackground))
    }
    
    // MARK: - Headline
    
    private var headline: some View {
        Text(title)
            .font(.system(size: 23, weight: .bold))
            .foregroundStyle(Color.label)
            .padding(EdgeInsets(top: 16, leading: layout.padding, bottom: .zero, trailing: layout.padding))
    }
    
    // MARK: - List
    
    private var list: some View {
        ScrollView(.horizontal) {
            LazyHStack(spacing: spacing) {
                content
            } //: LazyHStack
            .padding(EdgeInsets(top: .zero, leading: layout.padding, bottom: layout.margin, trailing: layout.padding))
            .scrollTargetLayout()
        } //: ScrollView
        .scrollIndicators(.hidden)
        .scrollTargetBehavior(.viewAligned)
    }
}

// MARK: - Preview

#Preview("Carusel") {
    HeadlinedCaruselView(title: "Cast") {
        RoundedRectangle(cornerRadius: 10)
            .foregroundStyle(Color.gray)
    } //: DetailCaruselView
}
