//
//  MainView.swift
//  Movies
//
//  Created by Ihor Myronishyn on 05.09.2023.
//

import SwiftUI

struct MainView: View {
    
    // MARK: - Properties
    
    @State private var selection: Int = .zero
    
    // MARK: - Body
    
    var body: some View {
        TabView(selection: $selection) {
            home
        } //: TabView
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

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
