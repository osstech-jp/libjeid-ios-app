//
//  DLReaderView.swift
//  libjeid-ios-app
//
//  Copyright © 2019 Open Source Solution Technology Corporation
//  All rights reserved.
//

import UIKit

class DLReaderView: UIView {
    let pin1Field: UITextField
    let pin2Field: UITextField
    let startButton: UIButton

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(frame: CGRect) {
        let explanation = CustomViewUtil.createTextView(UIScreen.main.bounds.size)
        explanation.text = "読み取り開始ボタンを押下後、端末を免許証にかざしてください。\n"
                           + "暗証番号2は省略可能です。その場合、顔写真および本籍は表示されません。"

        let pin1Label = CustomViewUtil.createTextView(UIScreen.main.bounds.size)
        pin1Label.text = "暗証番号1(4桁、必須)"
        let pin2Label = CustomViewUtil.createTextView(UIScreen.main.bounds.size)
        pin2Label.text = "暗証番号2(4桁、任意)"

        pin1Field = CustomViewUtil.createTextField(UIScreen.main.bounds.size)
        pin1Field.isSecureTextEntry = true
        pin1Field.keyboardType = UIKeyboardType.numberPad

        pin2Field = CustomViewUtil.createTextField(UIScreen.main.bounds.size)
        pin2Field.isSecureTextEntry = true
        pin2Field.keyboardType = UIKeyboardType.numberPad

        startButton = CustomViewUtil.createButton(UIScreen.main.bounds.size)
        startButton.setTitle("読み取り開始", for: .normal)

        let stackView = CustomViewUtil.createVerticalStackView(UIScreen.main.bounds.size)
        stackView.addArrangedSubview(explanation)
        stackView.addArrangedSubview(pin1Label)
        stackView.addArrangedSubview(pin1Field)
        stackView.addArrangedSubview(pin2Label)
        stackView.addArrangedSubview(pin2Field)
        stackView.addArrangedSubview(startButton)

        super.init(frame: frame)
        self.addSubview(stackView)

        stackView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        stackView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        stackView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if (previousTraitCollection!.hasDifferentColorAppearance(comparedTo: traitCollection)) {
            pin1Field.layer.borderColor = CustomColor.textFieldBorder.cgColor
            pin2Field.layer.borderColor = CustomColor.textFieldBorder.cgColor
        }
    }
}
