//
//  PaPagoModel.swift
//  again2007project
//
//  Created by 윤민섭 on 2017. 5. 31..
//  Copyright © 2017년 윤민섭. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

private let nClientId = "3IvzGHemVaIhuEmhpV0v"

class PaPagoModel {
    
    static let shared = PaPagoModel()
    
    // user defaults - 앱 상태 유지
    private let papagoDefaults = UserDefaults.standard
    
    // 영어로만 번역 (기계번역)
    private let language = "en"
    
    // 번역 전
    private var preSentence: String!
    
    // 번역 전 문장을 세팅
    func setPreSentence(text: String){
        preSentence = text
    }
    
    // 현재 상태 저장
    func saveState(pre: String, trans: String) {
        papagoDefaults.set(pre, forKey: "preTextView")
        papagoDefaults.set(trans, forKey: "translatedTextView")
    }
    
    // 현재 상태 확인
    func checkState() -> (String?, String?){
        guard let preText = papagoDefaults.string(forKey: "preTextView") else{
            return (nil,nil)
        }
        
        guard let translatedText = papagoDefaults.string(forKey: "translatedTextView") else{
            return (nil,nil)
        }
        
        return (preText, translatedText)
    }
    
    // 번역
    func requestTranslate(completion : @escaping (String)->Void){
        let url = "https://openapi.naver.com/v1/language/translate"
        let parameters = ["source":"ko","target":self.language,"text":self.preSentence] as [String : Any]
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
