//
//  PersonView.swift
//  Movies
//
//  Created by Ihor Myronishyn on 21.10.2023.
//

import SwiftUI
import NukeUI
import Nuke

@MainActor
struct PersonView: View {
    
    // MARK: - Properties
    
    let item: Person
    var side: CGFloat = 100
    
    struct Person: Identifiable {
        let id: Int
        let image: String?
        let name: String
        let description: String
    }
    
    // MARK: - Body
    
    var body: some View {
        VStack {
            avatar
            details
        } //: VStack
        .frame(width: side)
    }
    
    // MARK: - Avatar
    
    private var avatar: some View {
        ZStack {
            Color(uiColor: .systemGray4)
            
            if let image = item.image {
                LazyImage(url: URL(string: EndpointPath.image(image, compressed: true))) { state in
                    ZStack {
                        if let image = state.image {
                            image
                                .resizable()
                                .scaledToFill()
                        }
                    } //: ZStack
                    .animation(.default, value: state.isLoading)
                } //: LazyImage
                .processors([ImageProcessors.Resize(size: CGSize(width: side, height: side))])
            } else {
                Text(item.name.initials)
                    .font(.system(size: 35, weight: .medium, design: .rounded))
                    .foregroundStyle(Color.white)
            }
        } //: ZStack
        .frame(width: side, height: side)
        .clipShape(Circle())
    }
    
    // MARK: - Details
    
    private var details: some View {
        Group {
            Text(item.name)
                .font(.subheadline)
                .foregroundStyle(Color.label)
            
            if !item.description.isEmpty {
                Text(item.description)
                    .font(.caption)
                    .foregroundStyle(Color.secondary)
            }
        } //: Group
        .lineLimit(1)
    }
}

// MARK: - Preview

#Preview("Person") {
    PersonView(item: .init(id: .zero, image: nil, name: "Bob", description: "Director"))
}
