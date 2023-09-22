//
//  OpacityTransitionModifier.swift
//  Movies
//
//  Created by Ihor Myronishyn on 22.09.2023.
//

import SwiftUI

struct OpacityTransitionModifier: ViewModifier {
    
    // MARK: - Properties
    
    @Binding var offset: CGFloat
    let range: ClosedRange<CGFloat>
    
    private var opacity: CGFloat {
        if -offset > range.lowerBound {
            return abs(offset) >= range.upperBound ? 1 : (-offset - range.lowerBound) / (range.upperBound - range.lowerBound)
        }
        
        return .zero
    }
    
    // MARK: - Body
    
    func body(content: Content) -> some View {
        content
            .opacity(opacity)
    }
}
