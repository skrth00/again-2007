//
//  App.swift
//  again2007project
//
//  Created by red282 on 2017. 5. 28..
//  Copyright © 2017년 윤민섭. All rights reserved.
//

import UIKit
import MessageUI

enum App {
    
    case calendar
    case maps
    case clock
    case camera
    case photo
    case calculator
    case mamago
    case mail
    case weather
    case memo
    case message
    case reminder
    case video
    case stock
    case passbook
    case compass
    case newsstand
    case settings
    case contacts
    case music
    case facetime
    case safari
    case appStore
    case gameCenter
    case iTunes
    case phone
    
    var name: String {
        switch self {
        case .calendar: return "캘린더"
        case .maps: return "지도"
        case .clock: return "시계"
        case .camera: return "카메라"
        case .photo: return "사진"
        case .calculator: return "계산기"
        case .mamago: return "마마고"
        case .mail: return "메일"
        case .weather: return "날씨"
        case .memo: return "메모"
        case .message: return "메시지"
        case .reminder: return "미리알림"
        case .video: return "비디오"
        case .stock: return "주식"
        case .passbook: return "Passbook"
        case .compass: return "나침반"
        case .newsstand: return "뉴스스탠드"
        case .settings: return "설정"
        case .contacts: return "연락처"
        case .music: return "음악"
        case .facetime: return "FaceTime"
        case .safari: return "Safari"
        case .appStore: return "App Store"
        case .gameCenter: return "Game Center"
        case .iTunes: return "iTunes"
        case .phone: return "전화"
        }
    }
    
    var icon: UIImage {
        switch self {
        case .calendar: return #imageLiteral(resourceName: "캘린더")
        case .maps: return #imageLiteral(resourceName: "map")
        case .clock: return #imageLiteral(resourceName: "시계")
        case .camera: return #imageLiteral(resourceName: "카메라")
        case .photo: return #imageLiteral(resourceName: "사진")
        case .calculator: return #imageLiteral(resourceName: "계산기")
        case .mamago: return #imageLiteral(resourceName: "papago")
        case .mail: return #imageLiteral(resourceName: "메일")
        case .weather: return #imageLiteral(resourceName: "날씨")
        case .memo: return #imageLiteral(resourceName: "메모")
        case .message: return #imageLiteral(resourceName: "메시지")
        case .reminder: return #imageLiteral(resourceName: "미리알림")
        case .video: return #imageLiteral(resourceName: "비디오")
        case .stock: return #imageLiteral(resourceName: "주식")
        case .passbook: return #imageLiteral(resourceName: "Passbook")
        case .compass: return #imageLiteral(resourceName: "나침반")
        case .newsstand: return #imageLiteral(resourceName: "뉴스스탠드")
        case .settings: return #imageLiteral(resourceName: "설정")
        case .contacts: return #imageLiteral(resourceName: "연락처")
        case .music: return #imageLiteral(resourceName: "음악")
        case .facetime: return #imageLiteral(resourceName: "face_time")
        case .safari: return #imageLiteral(resourceName: "safari")
        case .appStore: return #imageLiteral(resourceName: "AppStore")
        case .gameCenter: return #imageLiteral(resourceName: "game_center")
        case .iTunes: return #imageLiteral(resourceName: "itunes")
        case .phone: return #imageLiteral(resourceName: "전화")
        }
    }
    
    func execute() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let vc = appDelegate.window!.rootViewController as! HomeVC
        
        switch self {
        case .calendar: vc.performSegue(withIdentifier: "calendarSegue", sender: self)
        case .maps: vc.performSegue(withIdentifier: "mapSegue", sender: self)
        case .clock: vc.performSegue(withIdentifier: "clockSegue", sender: self)
        case .camera: vc.executeCamera()
        case .photo: vc.executePhoto()
        case .calculator: vc.performSegue(withIdentifier: "calculatorSegue", sender: self)
        case .mamago: vc.performSegue(withIdentifier: "papagoSegue", sender: self)
        case .mail: break
        case .weather: vc.performSegue(withIdentifier: "weatherSegue", sender: self)
        case .memo: break
        case .message: vc.executeMessage()
        case .reminder: vc.performSegue(withIdentifier: "prenoticeSegue", sender: self)
        case .video: vc.performSegue(withIdentifier: "videoSegue", sender: self)
        case .stock: break
        case .passbook: break
        case .compass: break
        case .newsstand: break
        case .settings: vc.performSegue(withIdentifier: "settingSegue", sender: self)
        case .contacts: break
        case .music: break
        case .facetime: break
        case .safari: vc.performSegue(withIdentifier: "safariSegue", sender: self)
        case .appStore: vc.performSegue(withIdentifier: "appstoreSegue", sender: self)
        case .gameCenter: break
        case .iTunes: break
        case .phone: vc.executePhone()
        }
    }
}
