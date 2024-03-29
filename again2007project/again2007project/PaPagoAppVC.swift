//
//  PaPagoAppVC.swift
//  again2007project
//
//  Created by 윤민섭 on 2017. 5. 26..
//  Copyright © 2017년 윤민섭. All rights reserved.
//

import UIKit
import NaverSpeech

private let nClientId = "3IvzGHemVaIhuEmhpV0v"

class PaPagoAppVC: UIViewController {
    
    // 음성 인식 언어
    private let voiceLanguage : NSKRecognizerLanguageCode = .korean
    
    // object
    @IBOutlet weak var preTextView: UITextView!
    @IBOutlet weak var preHintLabel: UILabel!
    @IBOutlet weak var translatedTextView: UITextView!
    @IBOutlet weak var translatedHintLabel: UILabel!
    @IBOutlet weak var voiceRecordButton: UIButton!
    
    // constraints
    @IBOutlet weak var preTextViewHeight: NSLayoutConstraint!
    @IBOutlet weak var translatedTextViewHeight: NSLayoutConstraint!
    
    // naver speech
    let speechRecognizer: NSKRecognizer
    
    var voiceMessage: String = ""{
        willSet(newValue){
            preHintLabel.isHidden = true
            translatedHintLabel.isHidden = true
            preTextView.text = newValue
            
            PaPagoModel.shared.setPreSentence(text: newValue)
            PaPagoModel.shared.requestTranslate { (translatedText) in
                self.translatedTextView.text = translatedText
            }
        }
    }
    
    override var isEditing: Bool{
        willSet(newValue){
            if !newValue{
                preTextView.endEditing(true)
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        let configuration = NSKRecognizerConfiguration(clientID: nClientId)
        configuration?.canQuestionDetected = true
        self.speechRecognizer = NSKRecognizer(configuration: configuration)
        super.init(coder: aDecoder)
        self.speechRecognizer.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        checkAppState()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        PaPagoModel.shared.saveState(pre: self.preTextView.text, trans: self.translatedTextView.text)
    }
    
    func setup(){
        
        if !is7Height(){
            preTextViewHeight.constant = 200
            translatedTextViewHeight.constant = 200
            
            preTextView.frame.size.height = 200
            translatedTextView.frame.size.height = 200
        }
        
        preTextView.layer.addBorder(edge: UIRectEdge.bottom, color: UIColor.lightGray, thickness: 1)
        translatedTextView.layer.addBorder(edge: UIRectEdge.bottom, color: UIColor.lightGray, thickness: 1)
        
    }
    
    func is7Height() -> Bool{
        let screenHeight = UIScreen.main.bounds.height
        if screenHeight < 667 {
            return false
        } else{
            return true
        }
    }
    
    func checkAppState(){
        
        let text = PaPagoModel.shared.checkState()
        if text.0 != nil , text.1 != nil {
            if text.0 != "" {
                self.preTextView.text = text.0
                self.translatedTextView.text = text.1
                
                self.preHintLabel.isHidden = true
                self.translatedHintLabel.isHidden = true
            }
        }
    }
    
    @IBAction func useVoiceTranslate(_ sender: UIButton) {
        if self.speechRecognizer.isRunning {
            self.speechRecognizer.stop()
        } else {
            self.speechRecognizer.start(with: voiceLanguage)
            self.voiceRecordButton.isEnabled = false
        }
    }

}

extension PaPagoAppVC: UITextViewDelegate{
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.isEditing = false
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool{
        if(text == "\n"){
            self.isEditing = false
            return false
        } else{
            return true
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if textView.text.characters.count == 0{
            translatedTextView.text = ""
            preHintLabel.isHidden = false
            translatedHintLabel.isHidden = false
            
        } else{
            preHintLabel.isHidden = true
            translatedHintLabel.isHidden = true
            
            PaPagoModel.shared.setPreSentence(text: preTextView.text)
            PaPagoModel.shared.requestTranslate { (translatedText) in
                self.translatedTextView.text = translatedText
            }
        }
    }
}

// speech delegate
extension PaPagoAppVC: NSKRecognizerDelegate {
    
    public func recognizerDidEnterReady(_ aRecognizer: NSKRecognizer!) {
        // 준비되면 발생하는 메소드
        preTextView.text = ""
        translatedTextView.text = ""
        
        preHintLabel.isHidden = false
        translatedHintLabel.isHidden = false
        
        self.voiceRecordButton.isEnabled = true
    }
    public func recognizerDidEnterInactive(_ aRecognizer: NSKRecognizer!) {
        // 비활성화 되면 발생하는 메소드
        self.voiceRecordButton.isEnabled = true
    }
    public func recognizer(_ aRecognizer: NSKRecognizer!, didReceivePartialResult aResult: String!) {
        // 음성인식 메소드
        self.voiceMessage = aResult
    }
    public func recognizer(_ aRecognizer: NSKRecognizer!, didReceive aResult: NSKRecognizedResult!) {
        // 최종 음성 인식 메소드
        if let result = aResult.results.first as? String {
            self.voiceMessage = result
        }
    }
}

extension CALayer {
    
    func addBorder(edge: UIRectEdge, color: UIColor, thickness: CGFloat) {
        let border = CALayer()
        switch edge {
        case UIRectEdge.top:
            border.frame = CGRect(x:0, y:0, width:self.frame.width, height:thickness)
            break
        case UIRectEdge.bottom:
            border.frame = CGRect(x:0, y:self.frame.height - thickness, width:UIScreen.main.bounds.width, height:thickness)
            break
        case UIRectEdge.left:
            border.frame = CGRect(x:0, y:0, width:thickness, height:self.frame.height)
            break
        case UIRectEdge.right:
            border.frame = CGRect(x:self.frame.width - thickness, y:0, width:thickness, height:self.frame.height)
            break
        default:
            break
        }
        border.backgroundColor = color.cgColor;
        self.addSublayer(border)
    }
}
