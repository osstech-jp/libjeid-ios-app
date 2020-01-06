//
//  PinStatusViewController.swift
//  libjeid-ios-app
//
//  Copyright © 2019 Open Source Solution Technology Corporation
//  All rights reserved.
//

import CoreNFC
import UIKit
import libjeid

class PinStatusViewController: CustomViewController, NFCTagReaderSessionDelegate {
    var pinStatusView: PinStatusView!
    var session: NFCTagReaderSession?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "暗証番号ステータス"
        pinStatusView = PinStatusView(frame: self.view.frame)
        pinStatusView.startButton.addTarget(self, action: #selector(pushStartButton), for: .touchUpInside)

        let wrapperView = CustomWrapperView(self.view.frame, pinStatusView)
        wrapperView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        logView = wrapperView.logView
        scrollView = wrapperView.scrollView
        self.view.addSubview(wrapperView)
    }

    @objc func pushStartButton(sender: UIButton){
        print("startButton pushed")
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
                let reader = try JeidReader(tag)
                self.publishLog("# 暗証番号ステータスの読み取り開始")
                print("thread: \(Thread.current)")
                session.alertMessage = "\(msgReadingHeader)カード種別の判別..."
                let cardType = try reader.detectCardType()
                session.alertMessage += "成功"
                switch cardType {
                case .IN:
                    self.publishLog("カード種別: マイナンバーカード")
                    session.alertMessage = "\(msgReadingHeader)暗証番号ステータスの取得..."
                    let textAp = try reader.selectINText()
                    let textPin = try textAp.getPin()
                    let textPinA = try textAp.getPinA()
                    let textPinB = try textAp.getPinB()
                    var msg = "券面入力補助AP 暗証番号: \(textPin)\n"
                    msg += "券面入力補助AP 暗証番号A: \(textPinA)\n"
                    msg += "券面入力補助AP 暗証番号B: \(textPinB)\n"

                    let visualAp = try reader.selectINVisual()
                    let visualPinA = try visualAp.getPinA()
                    let visualPinB = try visualAp.getPinB()
                    session.alertMessage += "成功"
                    msg += "券面AP 暗証番号A: \(visualPinA)\n"
                    msg += "券面AP 暗証番号B: \(visualPinB)"
                    self.publishLog(msg)
                case .DL:
                    self.publishLog("カード種別: 運転免許証")
                    let ap = try reader.selectDL()
                    session.alertMessage = "\(msgReadingHeader)暗証番号ステータスの取得..."
                    let pin1 = try ap.getPin1()
                    let pin2 = try ap.getPin2()
                    session.alertMessage += "成功"
                    var msg = "暗証番号1: \(pin1)\n"
                    msg += "暗証番号2: \(pin2)"
                    self.publishLog(msg)
                case .JUKI:
                    self.publishLog("カード種別: 住基カード")
                default:
                    self.publishLog("カード種別: 不明")
                }
                session.alertMessage = "読み取り完了"
                session.invalidate()
            } catch {
                session.invalidate(errorMessage: session.alertMessage + "失敗")
                self.publishLog("\(error)")
            }
        }
    }
}
