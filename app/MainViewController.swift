//
//  MainViewController.swift
//  libjeid-ios-app
//
//  Copyright © 2019 Open Source Solution Technology Corporation
//  All rights reserved.
//

import UIKit

class MainViewController: CustomViewController {
    var mainView: MainView!

    override func loadView() {
        let bundleName = Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as! String
        let bundleShortVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
        self.title = bundleName + " " + bundleShortVersion
        mainView = MainView()
        mainView.inButton.addTarget(self, action: #selector(pushInButton), for: .touchUpInside)
        mainView.dlButton.addTarget(self, action: #selector(pushDlButton), for: .touchUpInside)
        mainView.rcButton.addTarget(self, action: #selector(pushRcButton), for: .touchUpInside)
        mainView.pinButton.addTarget(self, action: #selector(pushPinButton), for: .touchUpInside)

        let wrapperView = CustomWrapperView(mainView)
        scrollView = wrapperView.scrollView
        wrapperView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        wrapperView.logView.isHidden = true
        self.view = wrapperView
    }

    @objc func pushInButton(sender: UIButton){
        let nextViewController = INReaderViewController()
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }

    @objc func pushDlButton(sender: UIButton){
        let nextViewController = DLReaderViewController()
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }

    @objc func pushRcButton(sender: UIButton){
        let nextViewController = RCReaderViewController()
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }

    @objc func pushPinButton(sender: UIButton){
        let nextViewController = PinStatusViewController()
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }
}

