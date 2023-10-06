//
//  HeaderView.swift
//  Movies
//
//  Created by Ihor Myronishyn on 22.09.2023.
//

import SwiftUI

struct HeaderView: View {
    
    // MARK: - Properties
    
    @Environment(\.layout) private var layout
    @Environment(\.safeAreaInsets) private var insets
    
    @Binding var offset: CGFloat
    
    // MARK: - Body
    
    var body: some View {
        let lower = layout.height.slideshow / 2
        let upper = layout.height.slideshow - layout.height.header - insets.top
        
        HStack {
            Spacer()
            Text("Watch Now")
                .foregroundStyle(Color.label)
                .font(.system(size: 17, weight: .semibold))
            Spacer()
        } //: HStack
        .frame(height: layout.height.header)
        .padding(.top, insets.top)
        .background(Material.bar)
        .overlay(alignment: .bottom) {
            line
        }
        .modifier(OpacityTransitionModifier(offset: $offset, value: .constant(.zero), range: lower...upper))
        .ignoresSafeArea(.container, edges: .top)
    }
    
    // MARK: - Line
    
    private var line: some View {
        Rectangle()
            .foregroundStyle(Color.line)
            .frame(height: 0.3)
    }
}
