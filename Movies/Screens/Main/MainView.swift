//
//  MainView.swift
//  Movies
//
//  Created by Ihor Myronishyn on 05.09.2023.
//

import SwiftUI

@MainActor
struct MainView: View {
    
    // MARK: - Properties
    
    @Environment(\.horizontalSizeClass) private var horizontal
    @State private var navigation = Navigation()
    @State private var selection: Tab = .home
    
    // MARK: - Body
    
    var body: some View {
        GeometryReader { proxy in
            TabView(selection: $selection) {
                ForEach(Tab.allCases) { tab in
                    tab.destination
                        .tag(tab)
                        .toolbarBackground(.visible, for: .tabBar)
                        .tabItem {
                            tab.label
                        }
                } //: ForEach
            } //: TabView
            .environment(navigation)
            .environment(\.screenSize, proxy.size)
            .environment(\.safeAreaInsets, proxy.safeAreaInsets)
            .environment(\.layout.height.slide, horizontal == .compact ? proxy.size.width / 2 * 3 : proxy.size.width / 25 * 14)
        } //: GeometryReader
    }
}

// MARK: - Preview

#Preview("Main") {
    MainView()
}
