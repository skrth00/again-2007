//
//  AlarmViewController.swift
//  watch
//
//  Created by 이천지 on 2017. 5. 26..
//  Copyright © 2017년 project. All rights reserved.
//

import UIKit
import UserNotifications

class AlarmViewController: UIViewController {
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var showDateText: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UNUserNotificationCenter.current().delegate = self
        showDateText.text = "00:00"
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
        showDateText.text = "\(hour):\(min)"
        UNUserNotificationCenter.current().getNotificationSettings { (notificationSettings) in
            switch notificationSettings.authorizationStatus {
            case .notDetermined:
                self.requestAuthorization(completionHandler: { (success) in
                    guard success else { return }
                    self.scheduleLocalNotification()
                })
                
            case .authorized:
                self.scheduleLocalNotification()
            case .denied:
                print("Application Not Allowed to Display Notifications")
            }
        }
        
    }
    private func requestAuthorization(completionHandler: @escaping (_ success: Bool) -> ()) {
        // Request Authorization
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { (success, error) in
            if let error = error {
                print("Request Authorization Failed (\(error), \(error.localizedDescription))")
            }
            //
            completionHandler(success)
        }
    }
    
    private func scheduleLocalNotification() {
        // Create Notification Content
        let notificationContent = UNMutableNotificationContent()
        
        // Configure Notification Content
        notificationContent.title = "알람이 울려요"
        notificationContent.subtitle = showDateText.text!
        notificationContent.body = "ㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋ"
        
        var dateComponents = DateComponents()
        dateComponents.hour = Int(hour)
        dateComponents.minute = Int(min)
        // Add Trigger
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        //                let notificationTrigger = UNTimeIntervalNotificationTrigger(timeInterval: 5.0, repeats: false)
        
        // Create Notification Request
        let notificationRequest = UNNotificationRequest(identifier: "cocoacasts_local_notification", content: notificationContent, trigger: trigger)
        
        // Add Request to User Notification Center
        UNUserNotificationCenter.current().add(notificationRequest) { (error) in
            if let error = error {
                print("Unable to Add Notification Request (\(error), \(error.localizedDescription))")
            }
            print("success")
        }
        
    }
}

extension AlarmViewController: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert])
    }
    
}
