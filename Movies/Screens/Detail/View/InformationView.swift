//
//  InformationView.swift
//  Movies
//
//  Created by Ihor Myronishyn on 24.09.2023.
//

import SwiftUI

struct InformationView: View {
    
    // MARK: - Properties
    
    @Environment(\.layout) private var layout
    
    let title: String
    let items: [(String, String)]
    
    // MARK: - Body
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(title)
                .font(.system(size: 20, weight: .bold))
                .foregroundStyle(Color.label)
            container
        } //: VStack
        .padding(EdgeInsets(top: 16, leading: layout.padding, bottom: layout.margin, trailing: layout.padding))
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.systemGray6)
    }
    
    // MARK: - Container
    
    private var container: some View {
        VStack(alignment: .leading, spacing: 14) {
            ForEach(Array(items.enumerated()), id: \.offset) { index, item in
                VStack(alignment: .leading, spacing: 4) {
                    Text(item.0)
                        .foregroundColor(Color.label)
                        .frame(height: 14)
                    Text(item.1)
                        .foregroundStyle(Color.gray)
                        .textSelection(.enabled)
                } //: VStack
                .font(.system(size: 12, weight: .regular))
            } //: ForEach
        } //: VStack
    }
}

// MARK: - Preview

#Preview("Information") {
    InformationView(title: "Information", items: [("Studio", "Columbia Pictures"), ("Status", "Released"), ("Region of Origin", "United States")])
}
