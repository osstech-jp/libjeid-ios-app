//
//  OptionsMenuViewController.swift
//  libjeid-ios-app
//
//  Copyright © 2019 Open Source Solution Technology Corporation
//  All rights reserved.
//

import UIKit
import libjeid

class OptionsMenuViewController: UIViewController {
    var optionsMenuView: OptionsMenuView!
    var closeHandler: ((_ viewController: UIViewController) -> Void)?

    override func loadView() {
        self.title = "オプションメニュー"
        optionsMenuView = OptionsMenuView()
        optionsMenuView.aboutButton.addTarget(self, action: #selector(pushAboutButton), for: .touchUpInside)
        optionsMenuView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        optionsMenuView.isHidden = true
        self.view = optionsMenuView

        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapMenuView))
        view.addGestureRecognizer(tapRecognizer)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.showMenuView()
    }

    @objc func tapMenuView(_ sender: UITapGestureRecognizer) {
        let location = sender.location(in: optionsMenuView.rightView)
        if location.x < 0 || location.x > optionsMenuView.rightView.frame.width ||
            location.y < 0 || location.y > optionsMenuView.rightView.frame.height {
            self.dismiss(animated: false, completion: nil)
        }
    }

    @objc func pushAboutButton(sender: UIButton) {
        let bundleShortVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
        self.optionsMenuView.rightView.isHidden = true
        self.openAlertView("IDリーダー \(bundleShortVersion)",
                           "libjeid: \(BuildConfig.VERSION_NAME)\n" +
                            "Powerd by OSSTech")
    }

    func showMenuView() {
        let defaultRightViewSize = optionsMenuView.rightView.frame
        let defaultScrollViewSize = optionsMenuView.scrollView.frame
        optionsMenuView.rightView.frame.size.width = 0
        optionsMenuView.rightView.frame.size.height = 0
        optionsMenuView.scrollView.frame.size.width = 0
        optionsMenuView.scrollView.frame.size.height = 0
        optionsMenuView.rightView.center.x = defaultRightViewSize.minX + defaultRightViewSize.width
        optionsMenuView.rightView.center.y = defaultRightViewSize.minY
        optionsMenuView.rightView.alpha = 0.0
        optionsMenuView.scrollView.alpha = 0.0
        optionsMenuView.isHidden = false
        UIView.animate(withDuration: 0.2, delay: 0, options: [], animations: {
            self.optionsMenuView.rightView.frame.size.width = defaultRightViewSize.width
            self.optionsMenuView.rightView.frame.size.height = defaultRightViewSize.height
            self.optionsMenuView.scrollView.frame.size.width = defaultScrollViewSize.width
            self.optionsMenuView.scrollView.frame.size.height = defaultScrollViewSize.height
            self.optionsMenuView.rightView.center.x -= defaultRightViewSize.width
            self.optionsMenuView.rightView.alpha = 1.0
            self.optionsMenuView.scrollView.alpha = 1.0
        }, completion: nil)
    }

    func openAlertView(_ title: String, _ message: String) {
        DispatchQueue.main.async {
            let alertController: UIAlertController
                = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: { _ in
                self.closeHandler?(self)
            })
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
}

