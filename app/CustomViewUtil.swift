//
//  CustomViewUtil.swift
//  libjeid-ios-app
//
//  Copyright © 2019 Open Source Solution Technology Corporation
//  All rights reserved.
//

import UIKit

class CustomViewUtil: UIView {
    private static let TEXT_SIZE_DENOMINATOR = CGFloat(18)
    private static let SMALL_TEXT_SIZE_DENOMINATOR = CGFloat(24)
    private static let TEXT_FIELD_HEIGHT_DENOMINATOR = CGFloat(12)
    private static let BUTTON_LABEL_FONT_SIZE_DENOMINATOR = CGFloat(16)
    private static let STACK_VIEW_WIDE_SPACING_DENOMINATOR = CGFloat(20)
    private static let STACK_VIEW_NARROW_SPACING_DENOMINATOR = CGFloat(50)
    private static let AUTO_LAYOUT_PADDING_DENOMINATOR = CGFloat(20)

    static func getAutoLayoutPadding(_ size: CGSize) -> CGFloat {
        return CGFloat(min(size.width, size.height) / AUTO_LAYOUT_PADDING_DENOMINATOR)
    }

    static func createButton(_ size: CGSize) -> UIButton {
        let button = UIButton(type: .system)
        button.tintColor = CustomColor.buttonTitle
        button.backgroundColor = CustomColor.buttonBackground
        let fontSize = CGFloat(min(size.width, size.height) / BUTTON_LABEL_FONT_SIZE_DENOMINATOR)
        button.titleLabel?.font = UIFont.systemFont(ofSize: fontSize)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }

    static func createLogView(_ size: CGSize) -> UITextView {
        let textView = UITextView()
        textView.textColor = CustomColor.text
        let fontSize = CGFloat(min(size.width, size.height) / SMALL_TEXT_SIZE_DENOMINATOR)
        textView.font = UIFont.systemFont(ofSize: fontSize)
        textView.backgroundColor = CustomColor.background
        textView.isEditable = false
        textView.isScrollEnabled = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }

    static func createVerticalStackView(_ size: CGSize) -> UIStackView {
        let stackView = UIStackView(frame: .zero)
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        let spacing = CGFloat(min(size.width, size.height) / STACK_VIEW_WIDE_SPACING_DENOMINATOR)
        stackView.spacing = spacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }

    static func createNarrowVerticalStackView(_ size: CGSize) -> UIStackView {
        let stackView = UIStackView(frame: .zero)
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        let spacing = CGFloat(min(size.width, size.height) / STACK_VIEW_NARROW_SPACING_DENOMINATOR)
        stackView.spacing = spacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }

    static func createTextField(_ size: CGSize) -> UITextField {
        let textField = UITextField()
        textField.textColor = CustomColor.textFieldText
        let fontSize = CGFloat(min(size.width, size.height) / TEXT_SIZE_DENOMINATOR)
        textField.font = UIFont.systemFont(ofSize: fontSize)
        textField.backgroundColor = CustomColor.textFieldBackground
        textField.borderStyle = UITextField.BorderStyle.roundedRect
        textField.layer.borderColor = CustomColor.textFieldBorder.cgColor
        textField.layer.borderWidth = 1
        textField.translatesAutoresizingMaskIntoConstraints = false
        let textFieldHeight = CGFloat(min(size.width, size.height) / TEXT_FIELD_HEIGHT_DENOMINATOR)
        textField.heightAnchor.constraint(equalToConstant: CGFloat(textFieldHeight + textField.layer.borderWidth * 2))
            .isActive = true
        return textField
    }

    static func createTextView(_ size: CGSize) -> UITextView {
        let textView = UITextView()
        textView.textColor = CustomColor.text
        let fontSize = CGFloat(min(size.width, size.height) / TEXT_SIZE_DENOMINATOR)
        textView.font = UIFont.systemFont(ofSize: fontSize)
        textView.backgroundColor = CustomColor.background
        textView.textContainerInset = UIEdgeInsets.zero
        textView.isEditable = false
        textView.isScrollEnabled = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }
}
