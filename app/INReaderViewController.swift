//
//  INReaderViewController.swift
//  libjeid-ios-app
//
//  Copyright © 2019 Open Source Solution Technology Corporation
//  All rights reserved.
//

import CoreNFC
import UIKit
import libjeid

class INReaderViewController: CustomViewController, NFCTagReaderSessionDelegate {
    let MAX_PIN_LENGTH: Int = 4
    var inReaderView: INReaderView!
    var pinField: UITextField!
    var session: NFCTagReaderSession?
    private var pin: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "マイナンバーカードリーダー"
        inReaderView = INReaderView(frame: self.view.frame)
        pinField = inReaderView.pinField
        pinField.delegate = self
        inReaderView.startButton.addTarget(self, action: #selector(pushStartButton), for: .touchUpInside)

        let wrapperView = CustomWrapperView(self.view.frame, inReaderView)
        wrapperView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        logView = wrapperView.logView
        scrollView = wrapperView.scrollView
        self.view.addSubview(wrapperView)
    }

    @objc func pushStartButton(sender: UIButton){
        print("startButton pushed")
        self.pin = self.pinField!.text
        if let activeField = self.activeField {
            activeField.resignFirstResponder()
        }
        if (!NFCReaderSession.readingAvailable) {
            self.openAlertView("エラー", "お使いの端末はNFCに対応していません。")
            return
        }
        self.session = NFCTagReaderSession(pollingOption: [.iso14443], delegate: self, queue: DispatchQueue.global())
        self.session?.alertMessage = "カードに端末をかざしてください"
        self.session?.begin()
    }

    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        let currentStr: NSString = textField.text! as NSString
        let newStr: NSString = currentStr.replacingCharacters(in: range, with: string) as NSString
        return newStr.length <= MAX_PIN_LENGTH
    }

    func tagReaderSessionDidBecomeActive(_ session: NFCTagReaderSession) {
        print("tagReaderSessionDidBecomeActive: \(Thread.current)")
    }

    func tagReaderSession(_ session: NFCTagReaderSession,
                          didInvalidateWithError error: Error) {
        if let nfcError = error as? NFCReaderError {
            if nfcError.code != .readerSessionInvalidationErrorUserCanceled {
                print("tagReaderSession error: " + nfcError.localizedDescription)
                self.publishLog("エラー: " + nfcError.localizedDescription)
                if nfcError.code == .readerSessionInvalidationErrorSessionTerminatedUnexpectedly {
                    self.publishLog("しばらく待ってから再度お試しください")
                }
            }
        } else {
            print("tagReaderSession error: " + error.localizedDescription)
        }
        self.session = nil
    }

    func tagReaderSession(_ session: NFCTagReaderSession,
                          didDetect tags: [NFCTag]) {
        let msgReadingHeader = "読み取り中\n"
        let msgErrorHeader = "エラー\n"
        print("reader session thread: \(Thread.current)")
        let tag = tags.first!
        session.connect(to: tag) { (error: Error?) in
            print("connect thread: \(Thread.current)")
            if error != nil {
                print(error!)
                session.invalidate(errorMessage: "connect error")
                return
            }
            do {
                self.clearPublishedLog()
                if (self.pin == nil || self.pin!.isEmpty || self.pin!.count != 4) {
                    self.publishLog("4桁の暗証番号を入力してください")
                    session.invalidate(errorMessage: "\(msgErrorHeader)暗証番号が入力されていません")
                    return
                }
                let reader = try JeidReader(tag)
                session.alertMessage = "読み取り開始..."
                let cardType = try reader.detectCardType()
                if (cardType != CardType.IN) {
                    self.publishLog("マイナンバーカードではありません")
                    session.invalidate(errorMessage: "\(msgErrorHeader)マイナンバーカードではありません")
                    return
                }
                self.publishLog("# マイナンバーカードの読み取り開始")
                print("thread: \(Thread.current)")
                self.publishLog("## 券面入力補助APから情報を取得します")
                let textAp = try reader.selectINText()
                do {
                    session.alertMessage = "\(msgReadingHeader)暗証番号による認証..."
                    self.publishLog("### 暗証番号による認証")
                    try textAp.verifyPin(self.pin!)
                    self.publishLog("成功\n")
                    session.alertMessage += "成功"
                } catch let jeidError as JeidError {
                    switch jeidError {
                    case .invalidPin:
                        session.invalidate(errorMessage: "\(msgErrorHeader)認証失敗")
                        self.publishLog("失敗\n")
                        self.handleInvalidPinError(jeidError)
                        return
                    default:
                        throw jeidError
                    }
                }

                session.alertMessage = "\(msgReadingHeader)券面入力補助AP内の情報..."
                let textFiles = try textAp.readFiles()
                session.alertMessage += "成功"
                let textMyNumber = try textFiles.getMyNumber()
                self.publishLog("### 個人番号")
                self.publishLog(textMyNumber.description)

                var dataDict = Dictionary<String, Any>()
                if let myNumber = textMyNumber.myNumber {
                    dataDict["cardinfo-mynumber"] = myNumber
                }

                let textAttrs = try textFiles.getAttributes()
                self.publishLog("### 4情報")
                self.publishLog(textAttrs.description)
                if let name = textAttrs.name {
                    dataDict["cardinfo-name"] = name
                }
                if let birthDate = textAttrs.birthDate {
                    dataDict["cardinfo-birth"] = birthDate
                }
                if let sexString = textAttrs.sexString {
                    dataDict["cardinfo-sex"] = sexString
                }
                if let address = textAttrs.address {
                    dataDict["cardinfo-addr"] = address
                }

                self.publishLog("## 券面APから情報を取得します")
                let visualAp = try reader.selectINVisual()
                session.alertMessage = "\(msgReadingHeader)暗証番号による認証..."
                self.publishLog("### 暗証番号による認証")
                try visualAp.verifyPin(self.pin!)
                self.publishLog("成功\n")
                session.alertMessage += "成功"
                session.alertMessage = "\(msgReadingHeader)券面AP内の情報..."
                let visualFiles = try visualAp.readFiles()
                session.alertMessage += "成功"
                let visualEntries = try visualFiles.getEntries()
                self.publishLog("### 券面事項")
                self.publishLog(visualEntries.description)
                if let expireDate = visualEntries.expireDate {
                    dataDict["cardinfo-expire"] = expireDate
                }
                if let birthDate = visualEntries.birthDate {
                    dataDict["cardinfo-birth2"] = birthDate
                }
                if let sexString = visualEntries.sexString {
                    dataDict["cardinfo-sex2"] = sexString
                }
                if let nameImage = visualEntries.name {
                    let src = "data:image/png;base64,\(nameImage.base64EncodedString())"
                    dataDict["cardinfo-name-image"] = src
                }
                if let addressImage = visualEntries.address {
                    let src = "data:image/png;base64,\(addressImage.base64EncodedString())"
                    dataDict["cardinfo-address-image"] = src
                }
                if let photoData = visualEntries.photoData {
                    let src = "data:image/jp2;base64,\(photoData.base64EncodedString())"
                    dataDict["cardinfo-photo"] = src
                }

                let visualMyNumber = try visualFiles.getMyNumber()
                if let myNumberImage = visualMyNumber.myNumber {
                    let src = "data:image/png;base64,\(myNumberImage.base64EncodedString())"
                    dataDict["cardinfo-mynumber-image"] = src
                }

                session.alertMessage = "読み取り完了"
                session.invalidate()
                self.openWebView(dataDict)
            } catch {
                session.invalidate(errorMessage: session.alertMessage + "失敗")
                self.publishLog("\(error)")
            }
        }
    }

    func openWebView(_ dict: Dictionary<String, Any>) {
        DispatchQueue.main.async {
            do {
                let jsonData: Data = try JSONSerialization.data(withJSONObject: dict, options: [])
                var jsonStr: String? = String(bytes: jsonData, encoding: .utf8)
                jsonStr = jsonStr?.replacingOccurrences(of: "\\\"", with: "\\\\\"")

                let path = Bundle.main.path(forResource: "cardinfo", ofType: "html", inDirectory: "WebAssets/cardinfo")!
                let localHtmlUrl = URL(fileURLWithPath: path, isDirectory: false)
                let webViewController = WebViewController(localHtmlUrl, "render(\'\(jsonStr!)\');")
                webViewController.title = "マイナンバーカードビューア"
                self.navigationController?.pushViewController(webViewController, animated: true)
            } catch (let error) {
                print(error)
                return
            }
        }
    }

    func handleInvalidPinError(_ jeidError: JeidError) {
        let title: String
        let message: String
        guard case .invalidPin(let counter) = jeidError else {
            print("unexpected case")
            return
        }
        if (jeidError.isBlocked!) {
            title = "暗証番号がブロックされています"
            message = "市区町村窓口でブロック解除の申請を行ってください。"
        } else {
            title = "暗証番号が間違っています"
            message = "暗証番号を正しく入力してください。\n"
                + "残り\(counter)回間違えるとブロックされます。"
        }
        openAlertView(title, message)
    }
}
