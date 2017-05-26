//
//  SWViewController.swift
//  SimpleStopDemo
//
//  Created by Ravi Shankar on 22/07/14.
//  Copyright (c) 2014 Ravi Shankar. All rights reserved.
//

import UIKit

class StopWatchViewController: UIViewController,  UITableViewDataSource, UITableViewDelegate {
    
    var recordList = [String]()
    @IBOutlet var displayTimeLabel: UILabel!
    @IBOutlet weak var resetBtn: UIButton!
    @IBOutlet weak var recordTableView: UITableView!
    weak var timer: Timer?
    var startTime: Double = 0
    var time: Double = 0
    var elapsed: Double = 0
    var startStatus: Bool = false
    var restartStatus: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        recordTableView.reloadData()
    }
    @IBAction func start(_ sender: AnyObject) {
        if (startStatus) {
            stop()
            sender.setTitle("시작", for: .normal)
            resetBtn.setTitle("재시작", for: .normal)
            
        } else {
            start()
            resetBtn.setTitle("랩", for: .normal)
            sender.setTitle("스톱", for: .normal)
        }
    }
    
    @IBAction func restart(_ sender: AnyObject) {
        if (restartStatus) {
            stop()
            sender.setTitle("재시작", for: .normal)
            timer?.invalidate()
            
            startTime = 0
            time = 0
            elapsed = 0
            startStatus = false
            
            displayTimeLabel.text = "00:00:00"
        } else {
            lab()
            sender.setTitle("랩", for: .normal)
        }
        
    }
    
    func start() {
        
        startTime = Date().timeIntervalSinceReferenceDate - elapsed
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(updateCounter), userInfo: nil, repeats: true)
        startStatus = true
        restartStatus = false
        
    }
    
    func stop() {
        
        elapsed = Date().timeIntervalSinceReferenceDate - startTime
        timer?.invalidate()
        startStatus = false
        restartStatus = true
        
    }
    
    func lab(){
        recordList.insert(displayTimeLabel.text!, at: 0)
        recordTableView.reloadData()
    }
    
    func updateCounter() {
        
        time = Date().timeIntervalSinceReferenceDate - startTime
        
        let minutes = UInt8(time / 60.0)
        time -= (TimeInterval(minutes) * 60)
        
        let seconds = UInt8(time)
        time -= TimeInterval(seconds)
        
        let milliseconds = UInt8(time * 100)
        
        let strMinutes = String(format: "%02d", minutes)
        let strSeconds = String(format: "%02d", seconds)
        let strMilliseconds = String(format: "%02d", milliseconds)
        
        displayTimeLabel.text = "\(strMinutes):\(strSeconds):\(strMilliseconds)"
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
extension StopWatchViewController{
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(recordList.count < 0){
            return 0
        }else{
            return recordList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "STCell", for: indexPath) as! StopWatchTableViewCell
        cell.number.text = "랩 \(recordList.count - indexPath.row)"
        cell.record.text = recordList[indexPath.row]
        
        return cell
    }
    
    
    
}


