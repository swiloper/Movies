//
//  OffsetKey.swift
//  Movies
//
//  Created by Ihor Myronishyn on 19.09.2023.
//

import SwiftUI

struct OffsetKey: PreferenceKey {
    
    // MARK: - Properties
    
    static var defaultValue: CGRect = .zero
    
    // MARK: - Reduce
    
    static func reduce(value: inout CGRect, nextValue: () -> CGRect) {
        value = nextValue()
    }
}
