//
//  NavigationInsetsView.swift
//  Movies
//
//  Created by Ihor Myronishyn on 22.10.2023.
//

import SwiftUI

struct NavigationInsetsView: View {
    
    // MARK: - Properties
    
    @Binding var insets: EdgeInsets
    var navigationBarTitleDisplayMode: NavigationBarItem.TitleDisplayMode = .inline
    
    struct SafeAreaInsetsKey: PreferenceKey {
        static var defaultValue = EdgeInsets()
        static func reduce(value: inout EdgeInsets, nextValue: () -> EdgeInsets) {
            value = nextValue()
        }
    }
    
    // MARK: - Body
    
    var body: some View {
        NavigationStack {
            GeometryReader { proxy in
                Color.clear
                    .toolbar(.visible, for: .navigationBar)
                    .navigationBarTitleDisplayMode(navigationBarTitleDisplayMode)
                    .toolbarBackground(.hidden, for: .navigationBar)
                    .preference(key: SafeAreaInsetsKey.self, value: proxy.safeAreaInsets)
                    .onPreferenceChange(SafeAreaInsetsKey.self) { value in
                        insets = value
                    }
            } //: GeometryReader
        } //: NavigationStack
    }
}

// MARK: - Preview

#Preview("Insets") {
    NavigationInsetsView(insets: .constant(EdgeInsets()))
}
