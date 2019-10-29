//
//  DLReaderView.swift
//  libjeid-ios-app
//
//  Copyright © 2019 Open Source Solution Technology Corporation
//  All rights reserved.
//

import UIKit

class DLReaderView: UIView {
    let scrollView: UIScrollView
    let pin1Field: UITextField
    let pin2Field: UITextField
    let startButton: UIButton
    let logView: UITextView

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(frame: CGRect) {

        let screenWidth = UIScreen.main.bounds.size.width
        let screenHeight = UIScreen.main.bounds.size.height
        let textSize = CGFloat(min(screenWidth, screenHeight) / 18)
        let textFieldHeight = CGFloat(min(screenWidth, screenHeight) / 12)
        let logTextSize = CGFloat(min(screenWidth, screenHeight) / 24)
        let buttonLabelSize = CGFloat(min(screenWidth, screenHeight) / 16)
        let stackViewSpacing = CGFloat(min(screenWidth, screenHeight) / 40)
        let paddingSize = CGFloat(min(screenWidth, screenHeight) / 20)

        let explanation = UITextView()
        explanation.textColor = CustomColor.text
        explanation.font = UIFont.systemFont(ofSize: textSize)
        explanation.backgroundColor = CustomColor.background
        explanation.textContainerInset = UIEdgeInsets.zero
        explanation.isEditable = false
        explanation.isScrollEnabled = false
        explanation.text = "読み取り開始ボタンを押下後、端末を免許証にかざしてください。\n"
                           + "暗証番号2は省略可能です。その場合、顔写真および本籍は表示されません。"

        let pin1Label = UITextView()
        pin1Label.textColor = CustomColor.text
        pin1Label.font = UIFont.systemFont(ofSize: textSize)
        pin1Label.backgroundColor = CustomColor.background
        pin1Label.textContainerInset = UIEdgeInsets.zero
        pin1Label.isEditable = false
        pin1Label.isScrollEnabled = false
        pin1Label.text = "暗証番号1(4桁、必須)"

        let pin2Label = UITextView()
        pin2Label.textColor = CustomColor.text
        pin2Label.font = UIFont.systemFont(ofSize: textSize)
        pin2Label.backgroundColor = CustomColor.background
        pin2Label.textContainerInset = UIEdgeInsets.zero
        pin2Label.isEditable = false
        pin2Label.isScrollEnabled = false
        pin2Label.text = "暗証番号2(4桁、任意)"

        pin1Field = UITextField()
        pin1Field.textColor = CustomColor.textFieldText
        pin1Field.font = UIFont.systemFont(ofSize: textSize)
        pin1Field.backgroundColor = CustomColor.textFieldBackground
        pin1Field.borderStyle = UITextField.BorderStyle.roundedRect
        pin1Field.layer.borderColor = CustomColor.textFieldBorder.cgColor
        pin1Field.layer.borderWidth = 1
        pin1Field.isSecureTextEntry = true
        pin1Field.keyboardType = UIKeyboardType.numberPad
        pin1Field.translatesAutoresizingMaskIntoConstraints = false
        pin1Field.heightAnchor.constraint(equalToConstant: CGFloat(textFieldHeight + pin1Field.layer.borderWidth * 2)).isActive = true

        pin2Field = UITextField()
        pin2Field.textColor = CustomColor.textFieldText
        pin2Field.font = UIFont.systemFont(ofSize: textSize)
        pin2Field.backgroundColor = CustomColor.textFieldBackground
        pin2Field.borderStyle = UITextField.BorderStyle.roundedRect
        pin2Field.layer.borderColor = CustomColor.textFieldBorder.cgColor
        pin2Field.layer.borderWidth = 1
        pin2Field.isSecureTextEntry = true
        pin2Field.keyboardType = UIKeyboardType.numberPad
        pin2Field.translatesAutoresizingMaskIntoConstraints = false
        pin2Field.heightAnchor.constraint(equalToConstant: CGFloat(textFieldHeight + pin2Field.layer.borderWidth * 2)).isActive = true

        startButton = UIButton(type: .system)
        startButton.setTitle("読み取り開始", for: .normal)
        startButton.tintColor = CustomColor.buttonTint
        startButton.backgroundColor = CustomColor.buttonBackground
        startButton.titleLabel?.font = UIFont.systemFont(ofSize: buttonLabelSize)

        logView = UITextView()
        logView.textColor = CustomColor.text
        logView.font = UIFont.systemFont(ofSize: logTextSize)
        logView.backgroundColor = CustomColor.background
        logView.isEditable = false
        logView.isScrollEnabled = false

        let stackView = UIStackView(frame: .zero)
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = stackViewSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false

        stackView.addArrangedSubview(explanation)
        stackView.addArrangedSubview(pin1Label)
        stackView.addArrangedSubview(pin1Field)
        stackView.addArrangedSubview(pin2Label)
        stackView.addArrangedSubview(pin2Field)
        stackView.addArrangedSubview(startButton)
        stackView.addArrangedSubview(logView)

        scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(stackView)

        super.init(frame: frame)
        self.backgroundColor = CustomColor.background
        self.addSubview(scrollView)

        scrollView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor,
                                        constant: paddingSize).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor,
                                            constant: paddingSize).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor,
                                             constant: paddingSize * -1).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor,
                                           constant: paddingSize * -1).isActive = true

        stackView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        stackView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if (previousTraitCollection!.hasDifferentColorAppearance(comparedTo: traitCollection)) {
            pin1Field.layer.borderColor = CustomColor.textFieldBorder.cgColor
            pin2Field.layer.borderColor = CustomColor.textFieldBorder.cgColor
        }
    }
}
