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
    var layout: Layout {
        get { self[LayoutKey.self] }
        set { self[LayoutKey.self] = newValue }
    }
    
    var screenSize: CGSize {
        get { self[ScreenSizeKey.self] }
        set { self[ScreenSizeKey.self] = newValue }
    }
    
    var safeAreaInsets: EdgeInsets {
        get { self[SafeAreaInsetsKey.self] }
        set { self[SafeAreaInsetsKey.self] = newValue }
    }
}

// MARK: - Navigation

extension UINavigationController: UIGestureRecognizerDelegate {
    override open func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }
    
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1
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
    
    @ViewBuilder
    func offset(_ isObserve: Bool = true, completion: @escaping (CGRect) -> ()) -> some View {
        self
            .frame(maxWidth: .infinity)
            .overlay {
                if isObserve {
                    GeometryReader {
                        let frame = $0.frame(in: .global)
                        
                        Color.clear
                            .preference(key: OffsetKey.self, value: frame)
                            .onPreferenceChange(OffsetKey.self, perform: completion)
                    } //: GeometryReader
                }
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
    
    static let short: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM yyyy"
        formatter.locale = Locale(identifier: "en_us")
        return formatter
    }()
}

extension NumberFormatter {
    static let average: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.locale = Locale(identifier: "en_US")
        formatter.minimumFractionDigits = .zero
        formatter.maximumFractionDigits = 1
        return formatter
    }()
}

extension Axis.Set {
    static let none: Axis.Set = []
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
    static let space = " "
    
    var initials: String {
        self
            .split(separator: String.space)
            .map({ String($0) })
            .filter({ $0.count > 1 })
            .prefix(2)
            .map {
                guard let letter = $0.first(where: { $0.isLetter }) else { return .empty }
                return String(letter)
            }
            .joined()
            .uppercased()
    }
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

// MARK: - Array

extension Array {
    func item(at index: Int) -> Element? {
        return indices.contains(index) ? self[index] : nil
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
    static let line = Color("LineColor")
    static let label = Color(uiColor: .label)
    static let systemGray6 = Color(uiColor: .systemGray6)
}
