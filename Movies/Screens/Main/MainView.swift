//
//  MainView.swift
//  Movies
//
//  Created by Ihor Myronishyn on 05.09.2023.
//

import SwiftUI

struct MainView: View {
    
    // MARK: - Properties
    
    @Environment(\.horizontalSizeClass) private var horizontal
    
    @State private var selection: Int = .zero
    
    // MARK: - Body
    
    var body: some View {
        GeometryReader { proxy in
            TabView(selection: $selection) {
                home
            } //: TabView
            .environment(\.screenSize, proxy.size)
            .environment(\.safeAreaInsets, proxy.safeAreaInsets)
            .environment(\.layout.height.slide, horizontal == .compact ? proxy.size.width / 2 * 3 : proxy.size.width / 25 * 14)
        } //: GeometryReader
    }
    
    // MARK: - Home
    
    private var home: some View {
        HomeView()
            .tabItem {
                Image(systemName: "play.circle.fill")
                    .renderingMode(.template)
                Text("Watch Now")
            }
            .tag(Int.zero)
    }
}

// MARK: - Preview

#Preview("Main") {
    MainView()
}
