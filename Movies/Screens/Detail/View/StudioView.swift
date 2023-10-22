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
struct StudioView: View {
    
    // MARK: - Properties
    
    @Environment(\.layout) private var layout
    @Environment(\.screenSize) private var size
    @Environment(\.horizontalSizeClass) private var horizontal
    
    let item: Studio
    
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
            logo(item)
            
            Text(item.name)
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
                Text(studio.name.initials)
                    .font(.system(size: 80, weight: .medium, design: .rounded))
                    .foregroundStyle(Color.white)
            }
        } //: ZStack
        .frame(width: width, height: width * coefficient)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

// MARK: - Preview

#Preview("Studio") {
    StudioView(item: Studio(id: .zero, logo: .empty, name: .empty))
}
