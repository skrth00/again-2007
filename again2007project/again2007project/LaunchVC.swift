//
//  LaunchVC.swift
//  HomeScreen
//
//  Created by 윤민섭 on 2017. 5. 25..
//  Copyright © 2017년 윤민섭. All rights reserved.
//

import UIKit

class LaunchVC: UIViewController {

    var logoImage : UIImageView!
    var loadingBar : UIView!
    
    var loadingTimer = Timer()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewInit()
        loadingTimer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(loading), userInfo: nil, repeats:true)
    }
    
    func viewInit(){
        logoImage = UIImageView()
        logoImage.rcenter(y: 303.5, width: 50, height: 65, targetWidth: 375)
        logoImage.image = UIImage(named: "logo")
        self.view.addSubview(logoImage)
        
        loadingBar = UIView()
        loadingBar.rframe(x: 93.75, y: 423.5, width: 0, height: 4)
        loadingBar.backgroundColor = UIColor.black
        self.view.addSubview(loadingBar)
    }
    
    func loading(){
        if loadingBar.width >= 187.multiplyWidthRatio(){
            loadingTimer.invalidate()
            
            if let vc = parent as? HomeVC {
                vc.launchScreen.isHidden = true
                vc.homeBtn?.isHidden = false
            }
        } else{
            loadingBar.width = loadingBar.width.remultiplyWidthRatio() + 0.9375
        }
    }
    
}
