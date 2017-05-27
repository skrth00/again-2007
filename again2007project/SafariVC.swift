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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewInit()
    }
    
    func viewInit(){
        let url = NSURL (string: "https://www.naver.com");
        let requestObj = NSURLRequest(url: url as! URL);
        safariWebView.loadRequest(requestObj as URLRequest);
        safariWebView.scrollView.bounces = false
        safariWebView.scrollView.showsVerticalScrollIndicator = false
    }
    
    
}
