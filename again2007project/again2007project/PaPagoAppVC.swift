//
//  PaPagoAppVC.swift
//  again2007project
//
//  Created by 윤민섭 on 2017. 5. 26..
//  Copyright © 2017년 윤민섭. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class PaPagoAppVC: UIViewController, UITextViewDelegate {
    
    var language : String = "en"
    
    var englishBtn: UIButton!
    var chinaBtn: UIButton!
    var japanBtn: UIButton!
    
    var insertText: UITextView!
    var hintInsertView: UILabel!
    
    var responseText: UILabel!
    var hintResponseView: UILabel!
    var convertView: UIView!
    var convertBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewInit()
    }

    func viewInit(){
        
        let descriptionLabel = UILabel()
        descriptionLabel.rframe(x: 0, y: 20, width: 375, height: 20)
        descriptionLabel.textAlignment = .center
        descriptionLabel.text = "번역할 언어를 골라주세요"
        descriptionLabel.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 12.multiplyWidthRatio())
        descriptionLabel.textColor = UIColor.gray
        self.view.addSubview(descriptionLabel)
        
        englishBtn = UIButton()
        englishBtn.rframe(x: 30, y: 30, width: 75, height: 40)
        englishBtn.setImage(#imageLiteral(resourceName: "usa"), for: .normal)
        englishBtn.addTarget(self, action: #selector(languageBtnAction), for: .touchUpInside)
        englishBtn.tag = 0
        self.view.addSubview(englishBtn)
        
        chinaBtn = UIButton()
        chinaBtn.rframe(x: 150, y: 30, width: 75, height: 40)
        chinaBtn.setImage(#imageLiteral(resourceName: "china"), for: .normal)
        chinaBtn.addTarget(self, action: #selector(languageBtnAction), for: .touchUpInside)
        chinaBtn.tag = 1
        self.view.addSubview(chinaBtn)
        
        japanBtn = UIButton()
        japanBtn.rframe(x: 270, y: 30, width: 75, height: 40)
        japanBtn.setImage(#imageLiteral(resourceName: "japan"), for: .normal)
        japanBtn.addTarget(self, action: #selector(languageBtnAction), for: .touchUpInside)
        japanBtn.tag = 2
        self.view.addSubview(japanBtn)
        
        insertText = UITextView()
        insertText.delegate = self
        insertText.rframe(x: 0, y: 70, width: 375, height: 250)
        insertText.layer.addBorder(edge: .top, color: UIColor.lightGray, thickness: 1)
        insertText.layer.addBorder(edge: .bottom, color: UIColor.lightGray, thickness: 1)
        insertText.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 20.multiplyWidthRatio())
        self.view.addSubview(insertText)
        
        hintInsertView = UILabel()
        hintInsertView.rframe(x: 0, y: 185, width: 375, height: 20)
        hintInsertView.textAlignment = .center
        hintInsertView.text = "이곳에 번역할 문장을 입력하세요"
        hintInsertView.textColor = UIColor.lightGray
        self.view.addSubview(hintInsertView)
        
        responseText = UILabel()
        responseText.rframe(x: 0, y: 320, width: 375, height: 250)
        responseText.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 20.multiplyWidthRatio())
        self.view.addSubview(responseText)
        
        hintResponseView = UILabel()
        hintResponseView.rframe(x: 0, y: 435, width: 375, height: 20)
        hintResponseView.textAlignment = .center
        hintResponseView.text = "이곳에 번역된 문장이 나옵니다"
        hintResponseView.textColor = UIColor.lightGray
        self.view.addSubview(hintResponseView)
        
        convertView = UIView()
        convertView.rframe(x: 0, y: 570, width: 375, height: 97)
        convertView.addAction(target: self, action: #selector(translateAction))
        convertView.backgroundColor = UIColor(red: 0, green: 199/255, blue: 60/255, alpha: 1)
        self.view.addSubview(convertView)
     
        
        convertBtn = UIButton()
        convertBtn.rframe(x: 137.5, y: 570, width: 100, height: 100)
        convertBtn.setButton(imageName: "translate", targetController: self, action: #selector(translateAction), view)
    }
    
    func languageBtnAction(_ sender: UIButton){
        switch sender.tag {
        case 0:
            language = "en"
            break
        case 1:
            language = "zh-CN"
            break
        case 2:
            language = "ja"
            break
        default:
            break
        }
    }
    
    
    func textViewDidChange(_ textView: UITextView) {
        if textView.text.characters.count == 0{
            responseText.text = ""
            hintResponseView.isHidden = false
            hintInsertView.isHidden = false
        } else{
            hintResponseView.isHidden = true
            hintInsertView.isHidden = true
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool{
        if(text == "\n"){
            insertText.endEditing(true)
            return false
        } else{
            return true
        }
    }

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.insertText.endEditing(true)
    }
    
    func translateAction(){
        requestTranslate { (translatedText) in
            self.responseText.text = translatedText
            self.responseText.numberOfLines = 0
        }
    }
    
    func requestTranslate(completion : @escaping (String)->Void){
        let url = "https://openapi.naver.com/v1/language/translate"
        let parameters = ["source":"ko","target":self.language,"text":self.insertText.text] as [String : Any]
        let header = ["X-Naver-Client-Id":"p3P8WOtZvXwSbWcMZs5H","X-Naver-Client-Secret":"Egwu7b5CBL"]
        
        Alamofire.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: header).responseJSON { (response) in
            switch(response.result) {
                
            case .success(_):
                if let json = response.result.value{
                    let resp = JSON(json)
                    let translatedText = resp["message"]["result"]["translatedText"].stringValue
                    completion(translatedText)
                    
                }
                break
                
            case .failure(_):
                break
                
            }
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
