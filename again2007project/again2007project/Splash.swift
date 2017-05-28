//
//  LaunchVC.swift
//  HomeScreen
//
//  Created by 윤민섭 on 2017. 5. 25..
//  Copyright © 2017년 윤민섭. All rights reserved.
//

import UIKit

class SplashWindow: UIWindow {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup() {
        rootViewController = UIStoryboard(name: "Splash", bundle: nil).instantiateInitialViewController()
        windowLevel = UIWindowLevelStatusBar + 1
        isHidden = false
        runTimer()
    }
    
    var timer: DispatchSourceTimer?
    
    func runTimer() {
        timer = DispatchSource.makeTimerSource(queue: .main)
        timer?.scheduleOneshot(deadline: .now() + 2)
        timer?.setEventHandler { [weak self] in
            self?.timer?.cancel()
            self?.timer = nil
            self?.isHidden = true
        }
        timer?.resume()
    }
}

class SplashViewController: UIViewController {
    
    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var progressBar: UIProgressView!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        progressBar.layer.speed = 0.7
        progressBar.setProgress(1, animated: true)
    }
}
