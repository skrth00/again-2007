//
//  SafariVC.swift
//  again2007project
//
//  Created by 윤민섭 on 2017. 5. 27..
//  Copyright © 2017년 윤민섭. All rights reserved.
//

import UIKit

class SafariVC: UIViewController {
    
    @IBOutlet weak var safariWebView: UIWebView!
    
    let url = "https://www.naver.com"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    func setup(){
        SafariModel.shared.setUrl(urls: url)
        let requestObj = SafariModel.shared.getRequestObj()
        
        safariWebView.loadRequest(requestObj as URLRequest)
        safariWebView.scrollView.bounces = false
        safariWebView.scrollView.showsVerticalScrollIndicator = false
    }
}
