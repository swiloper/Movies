//
//  MoviesApp.swift
//  Movies
//
//  Created by Ihor Myronishyn on 04.09.2023.
//

import SwiftUI

@main
struct MoviesApp: App {
    var body: some Scene {
        WindowGroup {
            GeometryReader { proxy in
                MainView()
                    .environment(\.screenSize, proxy.size)
                    .environment(\.safeAreaInsets, proxy.safeAreaInsets)
            } //: GeometryReader
        } //: WindowGroup
    }
}
