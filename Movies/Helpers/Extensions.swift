//
//  Extensions.swift
//  Movies
//
//  Created by Ihor Myronishyn on 04.09.2023.
//

import SwiftUI

extension KeyedDecodingContainer {
    func decode<T>(key: K, default: T) throws -> T where T : Decodable {
        return try decodeIfPresent(T.self, forKey: key) ?? `default`
    }
}

// MARK: - Environment

extension EnvironmentValues {
    var screenSize: CGSize {
        get { self[ScreenSizeKey.self] }
        set { self[ScreenSizeKey.self] = newValue }
    }
    
    var safeAreaInsets: EdgeInsets {
        get { self[SafeAreaInsetsKey.self] }
        set { self[SafeAreaInsetsKey.self] = newValue }
    }
}

// MARK: - View

extension View {
    func border(radius: CGFloat, color: Color, width: CGFloat) -> some View {
        self
            .overlay {
                RoundedRectangle(cornerRadius: radius)
                    .strokeBorder(color, lineWidth: width)
            }
    }
}

// MARK: - Unwrapped

func unwrapped(_ string: String?) -> String {
    return string ?? .empty
}

// MARK: - Formatters

extension DateFormatter {
    static let `default`: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.locale = Locale(identifier: "en_us")
        return formatter
    }()
    
    static let year: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy"
        formatter.locale = Locale(identifier: "en_us")
        return formatter
    }()
}

// MARK: - Bundle

extension Bundle {
    var base: String? {
        return object(forInfoDictionaryKey: "BASE_URL") as? String
    }
    
    var token: String? {
        return object(forInfoDictionaryKey: "TOKEN") as? String
    }
}

// MARK: - String

extension String {
    static let empty = ""
}

// MARK: - Int

extension Int {
    func incremented() -> Int {
        return self + 1
    }
    
    func decremented() -> Int {
        return self - 1
    }
}

// MARK: - Data

extension Data {
    var pretty: NSString? {
        guard let object = try? JSONSerialization.jsonObject(with: self, options: []), let data = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]), let string = NSString(data: data, encoding: String.Encoding.utf8.rawValue) else { return nil }
        return string
    }
}

// MARK: - Color

extension Color {
    static let label = Color(uiColor: .label)
    static let systemGray6 = Color(uiColor: .systemGray6)
}
