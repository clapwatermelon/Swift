//
//  AutoViewController.swift
//  SpeechExample
//
//  Created by 박수현 on 07/04/2018.
//  Copyright © 2018 박수현. All rights reserved.
//

import UIKit
import NaverSpeech
//import Common
let ClientID = "s_AyqZajWMXL2eEXvsHL"

class AutoViewController: UIViewController {
    required init?(coder aDecoder: NSCoder) { // NSKRecognizer를 초기화 하는데 필요한 NSKRecognizerConfiguration을 생성
        let configuration = NSKRecognizerConfiguration(clientID: ClientID)
        configuration?.canQuestionDetected = true
        self.speechRecognizer = NSKRecognizer(configuration: configuration)
        super.init(coder: aDecoder)
        self.speechRecognizer.delegate = self
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupLanguagePicker()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        if self.isViewLoaded && self.view.window == nil {
            self.view = nil
        }
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let x = languagePickerButton.frame.minX
        let y = languagePickerButton.frame.maxY
        self.pickerView.frame = CGRect.init(x: x, y: y, width: languagePickerButton.bounds.size.width, height: self.pickerView.bounds.size.height)
    }
    @IBAction func languagePickerButtonTapped(_ sender: Any) {
        self.pickerView.isHidden = false
    }
    @IBAction func recognitionButtonTapped(_ sender: Any) { // 버튼 누르면 음성인식 시작
        if self.speechRecognizer.isRunning {
            self.speechRecognizer.stop()
        } else {
            self.speechRecognizer.start(with: self.languages.selectedLanguage)
            self.recognitionButton.isEnabled = false
            self.statusLabel.text = "Connecting......"
        }
    }
    @IBOutlet weak var languagePickerButton: UIButton!
    @IBOutlet weak var recognitionResultLabel: UILabel!
    @IBOutlet weak var recognitionButton: UIButton!
    @IBOutlet weak var statusLabel: UILabel!
    fileprivate let speechRecognizer: NSKRecognizer
    fileprivate let languages = Languages()
    fileprivate let pickerView = UIPickerView()
}

extension AutoViewController: NSKRecognizerDelegate { //NSKRecognizerDelegate protocol 구현
    
    public func recognizerDidEnterReady(_ aRecognizer: NSKRecognizer!) {
        print("Event occurred: Ready")
        self.statusLabel.text = "Connected"
        self.recognitionResultLabel.text = "Recognizing......"
        self.setRecognitionButtonTitle(withText: "Stop", color: .red)
        self.recognitionButton.isEnabled = true
    }
    public func recognizerDidDetectEndPoint(_ aRecognizer: NSKRecognizer!) {
        print("Event occurred: End point detected")
    }
    public func recognizerDidEnterInactive(_ aRecognizer: NSKRecognizer!) {
        print("Event occurred: Inactive")
        self.setRecognitionButtonTitle(withText: "Record", color: .blue)
        self.recognitionButton.isEnabled = true
        self.statusLabel.text = ""
    }
    public func recognizer(_ aRecognizer: NSKRecognizer!, didRecordSpeechData aSpeechData: Data!) {
        print("Record speech data, data size: \(aSpeechData.count)")
    }
    public func recognizer(_ aRecognizer: NSKRecognizer!, didReceivePartialResult aResult: String!) {
        print("Partial result: \(aResult)")
        self.recognitionResultLabel.text = aResult
    }
    public func recognizer(_ aRecognizer: NSKRecognizer!, didReceiveError aError: Error!) {
        print("Error: \(aError)")
        self.setRecognitionButtonTitle(withText: "Record", color: .blue)
        self.recognitionButton.isEnabled = true
    }
    public func recognizer(_ aRecognizer: NSKRecognizer!, didReceive aResult: NSKRecognizedResult!) {
        print("Final result: \(aResult)")
        if let result = aResult.results.first as? String {
            self.recognitionResultLabel.text = "Result: " + result
        }
    }
}
extension AutoViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.languages.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return languages.languageString(at: row)
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        languages.selectLanguage(at: row)
        languagePickerButton.setTitle(languages.selectedLanguageString, for: .normal)
        self.pickerView.isHidden = true
        if self.speechRecognizer.isRunning { //음성인식 중 언어를 변경하게 되면 음성인식을 즉시 중지(cancel)
            self.speechRecognizer.cancel()
            self.recognitionResultLabel.text = "Canceled"
            self.setRecognitionButtonTitle(withText: "Record", color: .blue)
            self.recognitionButton.isEnabled = true
        }
    }
}
fileprivate extension AutoViewController {
    func setupLanguagePicker() {
        self.view.addSubview(self.pickerView)
        self.pickerView.dataSource = self
        self.pickerView.delegate = self
        self.pickerView.showsSelectionIndicator = true
        self.pickerView.backgroundColor = UIColor.white
        self.pickerView.isHidden = true
    }
    func setRecognitionButtonTitle(withText text: String, color: UIColor) {
        self.recognitionButton.setTitle(text, for: .normal)
        self.recognitionButton.setTitleColor(color, for: .normal)
    }
}
