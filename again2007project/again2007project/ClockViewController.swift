//
//  ClockViewController.swift
//  watch
//
//  Created by 이천지 on 2017. 5. 26..
//  Copyright © 2017년 project. All rights reserved.
//

import UIKit

class ClockViewController: UIViewController {
    
    @IBOutlet weak var timeLabel: UILabel!
    
    let clock = Clock()
    var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(ClockViewController.updateTimeLabel), userInfo: nil, repeats: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateTimeLabel()
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(ClockViewController.updateTimeLabel), userInfo: nil, repeats: true)
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        timer?.invalidate()
        timer = nil
    }
    
    func updateTimeLabel() {
        let formatter = DateFormatter()
        formatter.timeStyle = .medium
        timeLabel.text = formatter.string(from: clock.currentTime as Date)
    }
    
    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.all
    }
    
    deinit {
        if let timer = self.timer {
            timer.invalidate()
        }
    }
}
