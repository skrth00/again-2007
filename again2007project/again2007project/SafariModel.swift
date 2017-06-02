//
//  SafariModel.swift
//  again2007project
//
//  Created by 윤민섭 on 2017. 6. 2..
//  Copyright © 2017년 윤민섭. All rights reserved.
//

import Foundation

class SafariModel{
    static let shared = SafariModel()
    
    var url = ""
    
    func setUrl(urls: String){
        self.url = urls
    }
    
    func getRequestObj() -> NSURLRequest{
        let url = NSURL (string: self.url);
        let requestObj = NSURLRequest(url: url! as URL);
        return requestObj
    }
}
