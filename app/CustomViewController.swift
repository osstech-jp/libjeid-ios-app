//
//  CustomViewController.swift
//  libjeid-ios-app
//
//  Copyright © 2019 Open Source Solution Technology Corporation
//  All rights reserved.
//

import CoreNFC
import UIKit
import libjeid

class CustomViewController: UIViewController, UITextFieldDelegate {
    var logView: UITextView?
    var scrollView: UIScrollView?
    var activeField: UITextField?
    private var previousKeyboardHeight: CGFloat = CGFloat(0)
    private var previousScreenSize: CGSize!
    private var textFieldIsEditing: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        textFieldIsEditing = false
        return true
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeField = textField
        textFieldIsEditing = true
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self,
                                       selector: #selector(keyboardWillShow(_:)),
                                       name: UIResponder.keyboardWillShowNotification, object: nil)
        notificationCenter.addObserver(self,
                                       selector: #selector(keyboardWillHide(_:)),
                                       name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        let notificationCenter = NotificationCenter.default
        notificationCenter.removeObserver(self)
    }

    @objc func keyboardWillShow(_ notification: Notification?) {
        print("keyboardWillShow")
        let keyboardFrameEnd = (notification?.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let boundsSize = UIScreen.main.bounds.size

        if let activeField = activeField,
            let scrollView = self.scrollView {
            let fieldBottom = (scrollView.frame.origin.y + activeField.frame.origin.y - scrollView.contentOffset.y)
                            + activeField.frame.height + 10.0
            let keyboardTop = boundsSize.height - keyboardFrameEnd.size.height
            let keyboardHeight = keyboardFrameEnd.size.height
            if fieldBottom >= keyboardTop {
                scrollView.contentOffset.y += fieldBottom - keyboardTop
            }
            scrollView.contentSize.height += keyboardHeight - previousKeyboardHeight
            previousKeyboardHeight = keyboardHeight
            previousScreenSize = self.view.bounds.size
        }
    }

    @objc func keyboardWillHide(_ notification: Notification?) {
        print("keyboardWillHide")
        if textFieldIsEditing {
            previousKeyboardHeight = CGFloat(0)
            return
        }
        if let _ = activeField,
            let scrollView = self.scrollView {
            let keyboardFrameEnd = (notification?.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
            let keyboardHeight = keyboardFrameEnd.size.height
            if (self.view.bounds.size.equalTo(previousScreenSize)) {
                scrollView.contentSize.height -= keyboardHeight
            }
            previousKeyboardHeight = CGFloat(0)
            activeField = nil
        }
    }

    func clearPublishedLog() {
        DispatchQueue.main.async {
            if let logView = self.logView {
                logView.isEditable = true
                logView.text = nil
                logView.isEditable = false
            }
        }
    }

    func publishLog(_ text: String) {
        DispatchQueue.main.async {
            if let logView = self.logView {
                logView.isEditable = true
                logView.insertText(text + "\n")
                logView.isEditable = false
            }
        }
    }

    func openAlertView(_ title: String, _ message: String) {
        DispatchQueue.main.async {
            let alertController: UIAlertController
                = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default) { action in
                print("alert closed")
            }
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
}
