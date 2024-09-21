//
//  ColorManager.swift
//  testedasd
//
//  Created by João Marcos on 19/09/24.
//

import UIKit

struct ColorManager {

    // MARK: - Cores do Projeto
    static let primary = ColorManager.colorFromHex("#FE3E6D")
    static let secondary = ColorManager.colorFromHex("#FFFFFF")
    static let details = ColorManager.colorFromHex("#F0F4F8")
    static let textSecondary = ColorManager.colorFromHex("#6B7076")
    static let textPrimary = ColorManager.colorFromHex("#3B3B3B")
    static let receivedColor = ColorManager.colorFromHex("#1A93DA")
    static let disableButton = ColorManager.colorFromHex("#C7CBCF")

    static func colorFromHex(_ hex: String) -> UIColor {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

        var rgb: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgb)

        let red = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgb & 0x0000FF) / 255.0

        return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
    }
}

