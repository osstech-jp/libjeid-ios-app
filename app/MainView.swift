//
//  MainView.swift
//  libjeid-ios-app
//
//  Copyright © 2019 Open Source Solution Technology Corporation
//  All rights reserved.
//

import UIKit

class MainView: UIView {
    let inButton: UIButton
    let dlButton: UIButton
    let epButton: UIButton

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(frame: CGRect) {

        let screenWidth = UIScreen.main.bounds.size.width
        let screenHeight = UIScreen.main.bounds.size.height
        let buttonLabelSize = CGFloat(min(screenWidth, screenHeight) / 16)
        let stackViewSpacing = CGFloat(min(screenWidth, screenHeight) / 16)
        let paddingSize = CGFloat(min(screenWidth, screenHeight) / 20)

        inButton = UIButton(type: .system)
        inButton.setTitle("マイナンバーカード", for: .normal)
        inButton.tintColor = CustomColor.buttonTint
        inButton.backgroundColor = CustomColor.buttonBackground
        inButton.titleLabel?.font = UIFont.systemFont(ofSize: buttonLabelSize)
        inButton.isHidden = true

        dlButton = UIButton(type: .system)
        dlButton.setTitle("運転免許証", for: .normal)
        dlButton.tintColor = CustomColor.buttonTint
        dlButton.backgroundColor = CustomColor.buttonBackground
        dlButton.titleLabel?.font = UIFont.systemFont(ofSize: buttonLabelSize)

        epButton = UIButton(type: .system)
        epButton.setTitle("パスポート", for: .normal)
        epButton.tintColor = CustomColor.buttonTint
        epButton.backgroundColor = CustomColor.buttonBackground
        epButton.titleLabel?.font = UIFont.systemFont(ofSize: buttonLabelSize)
        epButton.isHidden = true

        let stackView = UIStackView(frame: .zero)
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = stackViewSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false

        stackView.addArrangedSubview(inButton)
        stackView.addArrangedSubview(dlButton)
        stackView.addArrangedSubview(epButton)

        let scrollView = UIScrollView()
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
}
