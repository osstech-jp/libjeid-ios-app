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

        inButton = CustomViewUtil.createButton(UIScreen.main.bounds.size)
        inButton.setTitle("マイナンバーカード", for: .normal)
        inButton.isHidden = true

        dlButton = CustomViewUtil.createButton(UIScreen.main.bounds.size)
        dlButton.setTitle("運転免許証", for: .normal)

        epButton = CustomViewUtil.createButton(UIScreen.main.bounds.size)
        epButton.setTitle("パスポート", for: .normal)
        epButton.isHidden = true

        let stackView = CustomViewUtil.createStackView(UIScreen.main.bounds.size)
        stackView.addArrangedSubview(inButton)
        stackView.addArrangedSubview(dlButton)
        stackView.addArrangedSubview(epButton)

        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(stackView)

        super.init(frame: frame)
        self.backgroundColor = CustomColor.background
        self.addSubview(scrollView)

        let paddingSize = CustomViewUtil.getAutoLayoutPadding(UIScreen.main.bounds.size)
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
