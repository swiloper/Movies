//
//  EnvironmentKeys.swift
//  Movies
//
//  Created by Ihor Myronishyn on 05.09.2023.
//

import SwiftUI

struct ScreenSizeKey: EnvironmentKey {
    static let defaultValue: CGSize = .zero
}

struct SafeAreaInsetsKey: EnvironmentKey {
    static let defaultValue: EdgeInsets = EdgeInsets()
}
