//
//  CustomColor.swift
//  libjeid-ios-app
//
//  Copyright © 2019-2020 Open Source Solution Technology Corporation
//  All rights reserved.
//

import UIKit

class CustomColor {

    static var text: UIColor  {
        return dynamicColor(light: createUIColor(hex: 0x1A1A1D, alpha: 1.0),
                            dark: createUIColor(hex: 0xE5E5EA, alpha: 1.0))
    }

    static var background: UIColor  {
        return dynamicColor(light: createUIColor(hex: 0xFDFDFF, alpha: 1.0),
                            dark: createUIColor(hex: 0x1C1C20, alpha: 1.0))
    }

    static var buttonTitle: UIColor  {
        return dynamicColor(light: createUIColor(hex: 0x1A1A1D, alpha: 1.0),
                            dark: createUIColor(hex: 0xD1D1D8, alpha: 1.0))
    }

    static var buttonBackground: UIColor  {
        return dynamicColor(light: createUIColor(hex: 0xC7C7CC, alpha: 1.0),
                            dark: createUIColor(hex: 0x606066, alpha: 1.0))
    }

    static var textFieldText: UIColor  {
        return text
    }

    static var textFieldBackground: UIColor  {
        return dynamicColor(light: UIColor.clear,
                            dark: createUIColor(hex: 0x333336, alpha: 1.0))
    }

    static var textFieldBorder: UIColor  {
        return dynamicColor(light: createUIColor(hex: 0x66666A, alpha: 1.0),
                            dark: createUIColor(hex: 0x808084, alpha: 1.0))
    }

    private class func dynamicColor(light: UIColor, dark: UIColor) -> UIColor {
        return UIColor { (traitCollection) -> UIColor in
            switch traitCollection.userInterfaceStyle {
            case .unspecified, .light:
                return light
            case .dark:
                return dark
            @unknown default:
                return light
            }
        }
    }

    private class func createUIColor(hex: UInt, alpha: CGFloat) -> UIColor {
        let red = CGFloat((hex >> 16) & 0xff) / 0xff
        let green = CGFloat((hex >> 8) & 0xff) / 0xff
        let blue = CGFloat(hex & 0xff) / 0xff
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
}
