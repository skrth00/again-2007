//
//  ViewController.swift
//  again2007project
//
//  Created by 윤민섭 on 2017. 5. 25..
//  Copyright © 2017년 윤민섭. All rights reserved.
//

import UIKit
import DORM

class HomeVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    // main collection view
    @IBOutlet weak var mainCollectionView: UICollectionView!
    
    var apps : [(icon: UIImage, name: String)?] = [(icon: #imageLiteral(resourceName: "캘린더"), name: "캘린더"),
                                                   (icon: #imageLiteral(resourceName: "시계"), name: "시계"),
                                                   (icon: #imageLiteral(resourceName: "카메라"), name: "카메라"),
                                                   (icon: #imageLiteral(resourceName: "메일"), name: "메일"),
                                                   (icon: #imageLiteral(resourceName: "날씨"), name: "날씨"),
                                                   (icon: #imageLiteral(resourceName: "메모"), name: "메모"),
                                                   (icon: #imageLiteral(resourceName: "메시지"), name: "메시지"),
                                                   (icon: #imageLiteral(resourceName: "미리알림"), name: "미리알림"),
                                                   (icon: #imageLiteral(resourceName: "비디오"), name: "비디오"),
                                                   (icon: #imageLiteral(resourceName: "사진"), name: "사진"),
                                                   (icon: #imageLiteral(resourceName: "주식"), name: "주식"),
                                                   (icon: #imageLiteral(resourceName: "지도"), name: "지도"),
                                                   (icon: #imageLiteral(resourceName: "Passbook"), name: "Passbook"),
                                                   (icon: #imageLiteral(resourceName: "계산기"), name: "계산기"),
                                                   (icon: #imageLiteral(resourceName: "나침반"), name: "나침반"),
                                                   (icon: #imageLiteral(resourceName: "뉴스스탠드"), name: "뉴스스탠드"),
                                                   (icon: #imageLiteral(resourceName: "설정"), name: "설정"),
                                                   (icon: #imageLiteral(resourceName: "연락처"), name: "연락처"),
                                                   (icon: #imageLiteral(resourceName: "음악"), name: "음악"),
                                                   (icon: #imageLiteral(resourceName: "전화"), name: "전화"),
                                                   (icon: #imageLiteral(resourceName: "AppStore"), name: "AppStore"),
                                                   (icon: #imageLiteral(resourceName: "face_time"), name: "Face time"),
                                                   (icon: #imageLiteral(resourceName: "game_center"), name: "Game Center"),
                                                   (icon: #imageLiteral(resourceName: "itunes"), name: "itunes"),
                                                   (icon: #imageLiteral(resourceName: "safari"), name: "safari"),
                                                   ]
    var appsCount: [Int] = [10, 8, 7]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 배경화면
        self.view.layer.contents = UIImage(named: "background")?.cgImage
        
        layoutInit()
        viewInit()
        
    }
    
    func viewInit(){
        mainCollectionView.rframe(x: 0, y: 30, width: 375, height: 507)
        
        // user interaction
        mainCollectionView.isUserInteractionEnabled = true
        
        // show indicator
        mainCollectionView.showsHorizontalScrollIndicator = false
        
        // 페이징 가능
        mainCollectionView.isPagingEnabled = true
        
        // 델리게이트
        mainCollectionView.delegate = self
        mainCollectionView.dataSource = self
        
        // 배경
        mainCollectionView.backgroundColor = UIColor(white: 0, alpha: 0)
        
        

    }
    
    func layoutInit(){
        let layout = mainCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.sectionInset = UIEdgeInsetsMake(0,27.multiplyWidthRatio(),0,27.multiplyWidthRatio())
        layout.itemSize = CGSize(width: 60.multiplyWidthRatio() , height: 80.multiplyHeightRatio())
        layout.minimumLineSpacing = 27.multiplyWidthRatio()
        layout.scrollDirection = .horizontal
    }
    
    
    
}

extension HomeVC{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return appsCount.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 24
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "spaceCell", for: indexPath as IndexPath) as! ScreenCell
        cell.borderWidth = 1
        
        let section = indexPath.section
        //app[collectionAppCount + indexPath.row - 1
        let appCountInPage = appsCount[section]
        
        switch section {
        case 0:
            if indexPath.item < appCountInPage {
                cell.appIcon.layer.masksToBounds = true
                cell.appIcon.layer.cornerRadius = 11.multiplyWidthRatio()
                cell.appIcon.rframe(x: 0, y: 0, width: 60, height: 60)
                cell.appIcon.setImage(apps[(indexPath.item)]?.icon, for: .normal)
                cell.appIcon.tag = indexPath.item
                
                cell.appName.rframe(x: 0, y: 60, width: 60, height: 20)
                cell.appName.setLabel(text: "\(apps[indexPath.item]!.name)\(indexPath.item)", align: .center, fontSize: 12, color:UIColor.white)
            } else{
                cell.appIcon.setImage(nil, for: .normal)
                cell.appName.text = "\(indexPath.item)"
            }
        default:
            if indexPath.item < appCountInPage {
                cell.appIcon.layer.masksToBounds = true
                cell.appIcon.layer.cornerRadius = 11.multiplyWidthRatio()
                cell.appIcon.rframe(x: 0, y: 0, width: 60, height: 60)
                cell.appIcon.setImage(apps[(appsCount[section - 1] + indexPath.item)]?.icon, for: .normal)
                cell.appIcon.tag = indexPath.item
                
                cell.appName.rframe(x: 0, y: 60, width: 60, height: 20)
                cell.appName.setLabel(text: "\(apps[(appsCount[section - 1] + indexPath.item)]!.name)\(indexPath.item)", align: .center, fontSize: 12, color:UIColor.white)
            } else{
                cell.appIcon.setImage(nil, for: .normal)
                cell.appName.text = "\(indexPath.item)"
            }

        }

        return cell
    }
}

