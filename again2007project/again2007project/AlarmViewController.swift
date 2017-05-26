//
//  AlarmViewController.swift
//  watch
//
//  Created by 이천지 on 2017. 5. 26..
//  Copyright © 2017년 project. All rights reserved.
//

import UIKit


class AlarmViewController: UIViewController,  UITableViewDataSource, UITableViewDelegate {
    var alarmList = [String]()
    var passTime:String?
    
    @IBOutlet weak var alarmTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        alarmTableView.tableFooterView = UIView()
        //        showDateText.text = "\(hour):\(min)"
    }
    override func viewWillAppear(_ animated: Bool) {
        if passTime != nil {
            alarmList.append(passTime!)
            alarmTableView.reloadData()
            passTime = nil
        }
    }
    
    
    @IBAction func unwindToAlarm(segue: UIStoryboardSegue) {
        //self.viewWillAppear(true)
    }
    
}
extension AlarmViewController{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(alarmList.count < 0){
            return 0
        }else{
            return alarmList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AlarmTableCell", for: indexPath) as! AlarmTableCell
        
        cell.setTime.text = alarmList[indexPath.row]
        
        return cell
    }
    
}
