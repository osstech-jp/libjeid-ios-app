//
//  CustomWrapperView.swift
//  libjeid-ios-app
//
//  Copyright © 2019 Open Source Solution Technology Corporation
//  All rights reserved.
//

import UIKit

class CustomWrapperView: UIView {
    let scrollView: UIScrollView
    let logView: UITextView

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init(_ view: UIView) {
        let stackView = CustomViewUtil.createVerticalStackView(UIScreen.main.bounds.size)
        logView = CustomViewUtil.createLogView(UIScreen.main.bounds.size)
        stackView.addArrangedSubview(view)
        stackView.addArrangedSubview(logView)

        scrollView = UIScrollView()
        scrollView.addSubview(stackView)
        super.init(frame: .zero)
        self.addSubview(scrollView)
        self.backgroundColor = CustomColor.background

        stackView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        stackView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true

        let paddingSize = CustomViewUtil.getAutoLayoutPadding(UIScreen.main.bounds.size)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor,
                                        constant: paddingSize).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor,
                                            constant: paddingSize).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor,
                                             constant: paddingSize * -1).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor,
                                           constant: paddingSize * -1).isActive = true
    }
}
