//
//  AlarmDetailViewController.swift
//  again2007project
//
//  Created by 이천지 on 2017. 5. 26..
//  Copyright © 2017년 윤민섭. All rights reserved.
//

//
//  AlarmDetailViewController.swift
//  watch
//
//  Created by 이천지 on 2017. 5. 26..
//  Copyright © 2017년 project. All rights reserved.
//

import UIKit
import UserNotifications

class AlarmDetailViewController: UIViewController {
    @IBOutlet weak var datePicker: UIDatePicker!
    
    
    override func viewDidLoad() {
        //        UNUserNotificationCenter.current().delegate = self
        datePicker.addTarget(self, action: #selector(datePickerChanged(sender:)), for: .valueChanged)
    }
    
    var hour:String = ""
    var min:String = ""
    func datePickerChanged(sender: UIDatePicker) {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "HH mm"
        var tempText = formatter.string(from: sender.date)
        let tempArr = tempText.characters.split{$0 == " "}.map(String.init)
        hour = tempArr[0]
        min = tempArr[1]
    }
    
    @IBAction func editBtnAction(_ sender: Any) {
        
//        NSLog("awefawef")
        UNUserNotificationCenter.current().getNotificationSettings { (notificationSettings) in
            
            switch notificationSettings.authorizationStatus {
            case .notDetermined:
                self.requestAuthorization(completionHandler: { (success) in
                    guard success else { return }
                    self.scheduleLocalNotification()
                })
                
            case .authorized:
//                NSLog("authorized")
                self.scheduleLocalNotification()
                
            case .denied:
                print("Application Not Allowed to Display Notifications")
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "unwindSegue", sender: self)
                }
                
            }
            
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            if identifier == "unwindSegue" {
                let AlarmVC = segue.destination as! AlarmViewController
                AlarmVC.passTime = "\(hour) : \(min)"
            }
        }
    }
    
    private func requestAuthorization(completionHandler: @escaping (_ success: Bool) -> ()) {
        // Request Authorization
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { (success, error) in
            if let error = error {
                print("Request Authorization Failed (\(error), \(error.localizedDescription))")
            }
            
            completionHandler(success)
        }
    }
    
    private func scheduleLocalNotification() {
        // Create Notification Content
        let notificationContent = UNMutableNotificationContent()
        
        // Configure Notification Content
        notificationContent.title = "알람이 울려요"
        notificationContent.subtitle = "zzzzzz"
        notificationContent.body = "ㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋ"
        
        var dateComponents = DateComponents()
        dateComponents.hour = Int(hour)
        dateComponents.minute = Int(min)
        // Add Trigger
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        //                        let notificationTrigger = UNTimeIntervalNotificationTrigger(timeInterval: 5.0, repeats: false)
        
        // Create Notification Request
        let notificationRequest = UNNotificationRequest(identifier: UUID().uuidString, content: notificationContent, trigger: trigger)
        
        // Add Request to User Notification Center
        UNUserNotificationCenter.current().add(notificationRequest) { (error) in
            if let error = error {
                print("Unable to Add Notification Request (\(error), \(error.localizedDescription))")
            }
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "unwindSegue", sender: self)
            }
//            NSLog("success")
        }
        
    }
}

