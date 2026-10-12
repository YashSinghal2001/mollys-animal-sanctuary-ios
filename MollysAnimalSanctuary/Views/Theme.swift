import SwiftUI
import UIKit

extension Color {
    static let brandOrange = Color(light: 0xE8692C, dark: 0xFFB68F)
    static let brandTeal = Color(light: 0x2A7F7A, dark: 0x8FD3CD)
    static let primaryContainer = Color(light: 0xFFDCC8, dark: 0x7A3610)
    static let onPrimaryContainer = Color(light: 0x3A1300, dark: 0xFFDCC8)
    static let secondaryContainer = Color(light: 0xCDEDE9, dark: 0x1D4F4B)
    static let onSecondaryContainer = Color(light: 0x00201E, dark: 0xCDEDE9)
    static let cardBackground = Color(light: 0xF5E6DA, dark: 0x3A2F28)
    static let appBackground = Color(light: 0xFFF8F1, dark: 0x1C1714)

    init(light: UInt32, dark: UInt32) {
        self.init(UIColor { traits in
            UIColor(hex: traits.userInterfaceStyle == .dark ? dark : light)
        })
    }
}

extension UIColor {
    convenience init(hex: UInt32) {
        self.init(
            red: CGFloat((hex >> 16) & 0xFF) / 255,
            green: CGFloat((hex >> 8) & 0xFF) / 255,
            blue: CGFloat(hex & 0xFF) / 255,
            alpha: 1
        )
    }
}

extension Species {
    var gradient: LinearGradient {
        let colors: [UInt32]
        switch self {
        case .dog: colors = [0xFFD3B6, 0xFFA97A]
        case .cat: colors = [0xD7E8FF, 0x9DBEF0]
        case .rabbit: colors = [0xF7D9F0, 0xE3A5D3]
        case .bird: colors = [0xDDF5D6, 0xA3D99A]
        case .other: colors = [0xEDE3D6, 0xCDB89E]
        }
        return LinearGradient(
            colors: colors.map { Color(UIColor(hex: $0)) },
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
}
