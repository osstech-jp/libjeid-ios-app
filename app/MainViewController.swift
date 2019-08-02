//
//  MainViewController.swift
//  libjeid-ios-app
//
//  Copyright © 2019 Open Source Solution Technology Corporation
//  All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    var mainView: MainView!

    override func viewDidLoad() {
        super.viewDidLoad()
        let bundleName = Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as! String
        let bundleShortVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
        self.title = bundleName + " " + bundleShortVersion
        mainView = MainView(frame: self.view.frame)
        mainView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mainView.dlButton.addTarget(self, action: #selector(pushDlButton), for: .touchUpInside)
        self.view.addSubview(mainView)
    }

    @objc func pushDlButton(sender: UIButton){
        let nextViewController = DLReaderViewController()
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }
}

