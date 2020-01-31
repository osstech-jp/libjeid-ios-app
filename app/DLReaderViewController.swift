//
//  DLReaderViewController.swift
//  libjeid-ios-app
//
//  Copyright © 2019 Open Source Solution Technology Corporation
//  All rights reserved.
//

import CoreNFC
import UIKit
import libjeid

class DLReaderViewController: CustomViewController, NFCTagReaderSessionDelegate {
    let MAX_PIN_LENGTH: Int = 4
    var dlReaderView: DLReaderView!
    var pin1Field: UITextField!
    var pin2Field: UITextField!
    var session: NFCTagReaderSession?
    private var pin1: String?
    private var pin2: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "運転免許証リーダー"
        dlReaderView = DLReaderView(frame: self.view.frame)
        pin1Field = dlReaderView.pin1Field
        pin1Field.delegate = self
        pin2Field = dlReaderView.pin2Field
        pin2Field.delegate = self
        dlReaderView.startButton.addTarget(self, action: #selector(pushStartButton), for: .touchUpInside)

        let wrapperView = CustomWrapperView(self.view.frame, dlReaderView)
        wrapperView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        logView = wrapperView.logView
        scrollView = wrapperView.scrollView
        self.view.addSubview(wrapperView)
    }

    @objc func pushStartButton(sender: UIButton){
        print("startButton pushed")
        self.pin1 = self.pin1Field!.text
        self.pin2 = self.pin2Field!.text
        if let activeField = self.activeField {
            activeField.resignFirstResponder()
        }
        if (!NFCReaderSession.readingAvailable) {
            self.openAlertView("エラー", "お使いの端末はNFCに対応していません。")
            return
        }
        self.session = NFCTagReaderSession(pollingOption: [.iso14443], delegate: self, queue: DispatchQueue.global())
        self.session?.alertMessage = "免許証に端末をかざしてください"
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
        if (error as NSError).code != 200 {
            print("tagReaderSession error: " + error.localizedDescription)
            session.alertMessage = "error"
        }
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
                let reader = try JeidReader(tag)
                self.clearPublishedLog()
                session.alertMessage = "読み取り開始..."
                let cardType = try reader.detectCardType()
                if (cardType != CardType.DL) {
                    self.publishLog("運転免許証ではありません")
                    session.invalidate(errorMessage: "\(msgErrorHeader)運転免許証ではありません")
                    return
                }
                self.publishLog("# 運転免許証の読み取り開始")
                print("thread: \(Thread.current)")
                let ap = try reader.selectDL()

                // PINを入力せず共通データを読み出す場合は、
                // DriverLicenseAP.readCommonData()を利用できます
                // 通常はPINを入力した後、
                // DriverLicenseAP.readFiles()ですべてを読み出した後に
                // DriverLicenseFiles.getCommonData()を利用してください
                session.alertMessage = "\(msgReadingHeader)共通データ要素..."
                let commonData = try ap.readCommonData()
                session.alertMessage += "成功"
                print(commonData.description)
                self.publishLog("## 共通データ要素")
                self.publishLog(commonData.description)
                if (self.pin1 == nil || self.pin1!.isEmpty) {
                    self.publishLog("暗証番号1を入力してください")
                    session.invalidate(errorMessage: "\(msgErrorHeader)暗証番号1が入力されていません")
                    return
                }
                do {
                    try ap.verifyPin1(self.pin1!)
                } catch let jeidError as JeidError {
                    switch jeidError {
                    case .invalidPin:
                        session.invalidate(errorMessage: "\(msgErrorHeader)認証失敗(暗証番号1)")
                        self.handleInvalidPinError(jeidError, 1)
                        return
                    default:
                        throw jeidError
                    }
                }

                if (self.pin2 != nil && !self.pin2!.isEmpty) {
                    do {
                        try ap.verifyPin2(self.pin2!)
                    } catch let jeidError as JeidError {
                        switch jeidError {
                        case .invalidPin:
                            session.invalidate(errorMessage: "\(msgErrorHeader)認証失敗(暗証番号2)")
                            self.handleInvalidPinError(jeidError, 2)
                            return
                        default:
                            throw jeidError
                        }
                    }
                }

                session.alertMessage = "\(msgReadingHeader)ファイルの読み出し..."
                let files = try ap.readFiles()
                session.alertMessage += "成功"
                let entries = try files.getEntries()
                self.publishLog("## 記載事項(本籍除く)")
                self.publishLog(entries.description)

                let extChars = try files.getExternalCharacters()

                var dataDict = Dictionary<String, Any>()
                dataDict["dl-name"] = try entries.nameHtml(extChars)
                if let kana = entries.kana {
                    dataDict["dl-kana"] = kana
                }
                if let birthDate = entries.birthDate {
                    dataDict["dl-birth"] = birthDate.stringValue
                }
                dataDict["dl-addr"] = try entries.addressHtml(extChars)
                if let issueDate = entries.issueDate {
                    dataDict["dl-issue"] = issueDate.stringValue
                }
                if let refNumber = entries.refNumber {
                    dataDict["dl-ref"] = refNumber
                }
                if let colorClass = entries.colorClass {
                    dataDict["dl-color-class"] = colorClass
                }
                if let expireDate = entries.expireDate {
                    dataDict["dl-expire"] = expireDate.stringValue
                    let now = Date()
                    let date = expireDate.dateValue.addingTimeInterval(60 * 60 * 24 - 1)
                    dataDict["dl-is-expired"] = String(now > date)
                }
                if let licenseNumber = entries.licenseNumber {
                    dataDict["dl-number"] = licenseNumber
                }
                if let pscName = entries.pscName {
                    dataDict["dl-sc"]
                        = pscName.replacingCharacters(in: pscName.range(of: "公安委員会")!, with: "")
                }

                var i: Int = 1
                for conditionHtml in try entries.conditionsHtml(extChars) {
                    dataDict[String(format: "dl-condition%d", i)] = conditionHtml
                    i += 1
                }

                if let categories = entries.categories {
                    var categoriesDict: [Dictionary<String, Any>] = []
                    for category in categories {
                        var obj = Dictionary<String, Any>()
                        obj["tag"] = category.tag
                        obj["name"] = category.name
                        obj["date"] = category.date.stringValue
                        obj["licensed"] = category.isLicensed
                        categoriesDict.append(obj)
                    }
                    dataDict["dl-categories"] = categoriesDict
                }

                let changedEntries = try files.getChangedEntries()
                self.publishLog("## 記載事項変更等(本籍除く)")
                self.publishLog(changedEntries.description)

                var remarks: [Dictionary<String, String>] = []
                if (changedEntries.isChanged) {
                    for newName in changedEntries.newNames! {
                        var dict = Dictionary<String, String>()
                        dict["label"] = "新氏名"
                        dict["text"] = newName
                        remarks.append(dict)
                    }
                    for newAddr in changedEntries.newAddresses! {
                        var dict = Dictionary<String, String>()
                        dict["label"] = "新住所"
                        dict["text"] = newAddr
                        remarks.append(dict)
                    }
                    for newCond in changedEntries.newConditions! {
                        var dict = Dictionary<String, String>()
                        dict["label"] = "新条件"
                        dict["text"] = newCond
                        remarks.append(dict)
                    }
                    for condCancel in changedEntries.conditionCancellations! {
                        var dict = Dictionary<String, String>()
                        dict["label"] = "条件解除"
                        dict["text"] = condCancel
                        remarks.append(dict)
                    }
                }

                do {
                    let registeredDomicile = try files.getRegisteredDomicile()
                    dataDict["dl-registered-domicile"] = try registeredDomicile.registeredDomicileHtml(extChars)

                    let photo = try files.getPhoto()
                    if let photoData = photo.photoData {
                        let src = "data:image/jp2;base64,\(photoData.base64EncodedString())"
                        dataDict["dl-photo"] = src
                    }

                    let changedRegDomicile = try files.getChangedRegisteredDomicile()
                    var newRegDomiciles: [Dictionary<String, String>] = []
                    if (changedRegDomicile.isChanged) {
                        for newRegDomicile in changedRegDomicile.newRegisteredDomiciles! {
                            var dict = Dictionary<String, String>()
                            dict["label"] = "新本籍"
                            dict["text"] = newRegDomicile
                            newRegDomiciles.append(dict)
                        }
                    }
                    remarks += newRegDomiciles

                    let signature = try files.getSignature()
                    self.publishLog("## 電子署名")
                    if let signatureSubject = signature.subject {
                        self.publishLog("Subject: \(signatureSubject)")
                        dataDict["dl-signature-subject"] = signatureSubject
                    }
                    if let signatureSKI = signature.subjectKeyIdentifier {
                        let signatureSkiStr = signatureSKI.map { String(format: "%.2hhx", $0) }.joined(separator: ":")
                        self.publishLog("Subject Key Identifier: \(signatureSkiStr)")
                        dataDict["dl-signature-ski"] = signatureSkiStr
                    }

                    // 真正性検証
                    do {
                        let result = try files.validate()
                        dataDict["dl-verified"] = result.isValid
                        self.publishLog("署名検証: \(result.isValid)\n")
                    } catch {
                        self.publishLog("\(error)")
                    }
                } catch (JeidError.fileNotFound(message: _)) {
                    // PIN2を入力していない場合、filesオブジェクトは
                    // JeidError.fileNotFound(message: String)をスローします
                }

                dataDict["dl-remarks"] = remarks
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

                let path = Bundle.main.path(forResource: "dl", ofType: "html", inDirectory: "WebAssets/dl")!
                let localHtmlUrl = URL(fileURLWithPath: path, isDirectory: false)
                let webViewController = WebViewController(localHtmlUrl, "render(\'\(jsonStr!)\');")
                webViewController.title = "運転免許証ビューア"
                self.navigationController?.pushViewController(webViewController, animated: true)
            } catch (let error) {
                print(error)
                return
            }
        }
    }

    func handleInvalidPinError(_ jeidError: JeidError, _ pinIndex: Int) {
        let title: String
        let message: String
        guard case .invalidPin(let counter) = jeidError else {
            print("unexpected case")
            return
        }
        if (jeidError.isBlocked!) {
            title = "暗証番号\(pinIndex)がブロックされています"
            message = "警察署でブロック解除の申請を行ってください。"
        } else {
            title = "暗証番号\(pinIndex)が間違っています"
            message = "暗証番号\(pinIndex)を正しく入力してください。\n"
                + "残り\(counter)回間違えるとブロックされます。"
        }
        openAlertView(title, message)
    }
}
