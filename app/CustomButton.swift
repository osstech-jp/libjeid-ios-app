//
//  CustomButton.swift
//  libjeid-ios-app
//
//  Copyright © 2020 Open Source Solution Technology Corporation
//  All rights reserved.
//

import UIKit

class CustomButton: UIButton {
    private var _normalColor: UIColor?
    private var _highlightedColor: UIColor?

    var highlightedBackgroundColor: UIColor? {
        get {
            return self._highlightedColor
        }
        set(newValue) {
            self._highlightedColor = newValue
        }
    }

    override open var backgroundColor: UIColor? {
        didSet {
            self._normalColor = self.backgroundColor
        }
    }

    override open var isHighlighted: Bool {
        didSet {
            if isHighlighted {
                super.backgroundColor = self._highlightedColor
            } else {
                super.backgroundColor = self._normalColor
            }
        }
    }
}
