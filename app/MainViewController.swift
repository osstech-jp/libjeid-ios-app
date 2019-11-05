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

    override func viewDidLoad() {
        super.viewDidLoad()
        let bundleName = Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as! String
        let bundleShortVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
        self.title = bundleName + " " + bundleShortVersion
        mainView = MainView(frame: self.view.frame)
        mainView.inButton.addTarget(self, action: #selector(pushInButton), for: .touchUpInside)
        mainView.dlButton.addTarget(self, action: #selector(pushDlButton), for: .touchUpInside)

        let wrapperView = CustomWrapperView(self.view.frame, mainView)
        scrollView = wrapperView.scrollView
        wrapperView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        wrapperView.logView.isHidden = true
        self.view.addSubview(wrapperView)
    }

    @objc func pushInButton(sender: UIButton){
        let nextViewController = INReaderViewController()
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }

    @objc func pushDlButton(sender: UIButton){
        let nextViewController = DLReaderViewController()
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }
}

