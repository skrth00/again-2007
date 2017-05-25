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
    var homeBtn: UIImageView?
    var viewControllerList = [UIViewController]()
    
    // main collection view
    @IBOutlet weak var mainCollectionView: UICollectionView!
    
//<<<<<<< Updated upstream
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

    
    var appButtons : [UIButton] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 배경화면
        self.view.layer.contents = UIImage(named: "background")?.cgImage
        
        layoutInit()
        viewInit()
        setHomeBtn()
        let longpress = UILongPressGestureRecognizer(target: self, action: #selector(longPressGestureRecognized))
        mainCollectionView.addGestureRecognizer(longpress)
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
    override func viewDidAppear(_ animated: Bool) {
        UIApplication.shared.keyWindow?.addSubview(homeBtn!) // home버튼 최상위뷰에 등록
    }
    
    func setHomeBtn(){
        let homeBtnSize:CGFloat = 40
        homeBtn = UIImageView(frame:CGRect(x: 0, y: self.view.frame.size.height - homeBtnSize, width: homeBtnSize, height:homeBtnSize))
        homeBtn?.backgroundColor = UIColor.lightGray
        
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(HomeVC.doubleTapDetected))
        doubleTap.numberOfTapsRequired = 2 // you can change this value
        homeBtn?.addGestureRecognizer(doubleTap)
        
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(HomeVC.singleTapDetected))
        singleTap.numberOfTapsRequired = 1 // you can change this value
        homeBtn?.addGestureRecognizer(singleTap)
        
        homeBtn?.isUserInteractionEnabled = true
        
        singleTap.require(toFail: doubleTap)
        singleTap.delaysTouchesBegan = true
        doubleTap.delaysTouchesBegan = true
        
        let dragGesture = UIPanGestureRecognizer(target: self, action: #selector(HomeVC.handlePan))
        homeBtn?.addGestureRecognizer(dragGesture)
    }
    
    // home button drag action
    func handlePan(target: UIPanGestureRecognizer!) {
        
        if target.state == UIGestureRecognizerState.began {
            return
        }
        if target.state == UIGestureRecognizerState.changed{
            UIView.animate(withDuration: 0.1) {
                let locationInView = target.location(in: self.view)
                self.homeBtn?.center.x = locationInView.x
                self.homeBtn?.center.y = locationInView.y
            }
        }
        
        if target.state == UIGestureRecognizerState.ended {
            let centerX = self.view.frame.size.width / 2 // x의 중앙 좌표
            let superViewY = self.view.frame.size.height //height 전체길이
            let xPriorityLength:CGFloat = 50
            let btnHarfLength:CGFloat = 20
            var position = CGPoint(x: 0, y: 0)
            let locationInView = target.location(in: self.view)
            if(locationInView.x < centerX) {
                position.x = btnHarfLength
            } else {
                position.x = self.view.frame.size.width - btnHarfLength
            }
            if(locationInView.y < xPriorityLength) {
                position.y = btnHarfLength
                position.x = locationInView.x
            } else if(locationInView.y > superViewY - xPriorityLength) {
                position.y = superViewY - btnHarfLength
                position.x = locationInView.x
            } else {
                position.y = locationInView.y
            }
            
            
            UIView.animate(withDuration: 0.25) {
                self.homeBtn?.center.x = position.x
                self.homeBtn?.center.y = position.y
            }
            return
        }
        
    }
    
    //single tap Action
    func singleTapDetected() {
        dismiss(animated: true, completion: nil)
        print("Imageview Clicked")
    }
    //double tap Action
    func doubleTapDetected() {
        print("Imageview double Clicked")
    }

    
    func longPressGestureRecognized(gestureRecognizer: UIGestureRecognizer) {
        let longPress = gestureRecognizer as! UILongPressGestureRecognizer
        let state = longPress.state
        let locationInView = longPress.location(in: mainCollectionView)
        
        let indexPath = mainCollectionView.indexPathForItem(at: locationInView)
        struct My {
            static var cellSnapshot : UIView? = nil
            static var cellIsAnimating : Bool = false
            static var cellNeedToShow : Bool = false
        }
        struct Path {
            static var initialIndexPath : IndexPath? = nil
        }
        
        switch state {
        case UIGestureRecognizerState.began:
            if indexPath != nil {
                Path.initialIndexPath = indexPath as IndexPath? as IndexPath?
                let cell = mainCollectionView.cellForItem(at: indexPath!) as UICollectionViewCell!
                My.cellSnapshot = snapshotOfCell(inputView: cell!)
                
                var center = cell?.center
                My.cellSnapshot!.center = center!
                My.cellSnapshot!.alpha = 0.0
                mainCollectionView.addSubview(My.cellSnapshot!)
                
                UIView.animate(withDuration: 0.25, animations: { () -> Void in
                    center?.x = locationInView.x
                    center?.y = locationInView.y
                    My.cellIsAnimating = true
                    My.cellSnapshot!.center = center!
                    My.cellSnapshot!.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
                    My.cellSnapshot!.alpha = 0.98
                    cell?.alpha = 0.0
                }, completion: { (finished) -> Void in
                    if finished {
                        My.cellIsAnimating = false
                        if My.cellNeedToShow {
                            My.cellNeedToShow = false
                            UIView.animate(withDuration: 0.25, animations: { () -> Void in
                                cell?.alpha = 1
                            })
                        } else {
                            cell?.isHidden = true
                        }
                    }
                })
            }
            
        case UIGestureRecognizerState.changed:
            if My.cellSnapshot != nil {
                var center = My.cellSnapshot!.center
                center.x = locationInView.x
                center.y = locationInView.y
                
                print("centerX : \(center.x)")
                print("centerY : \(center.y)")
                My.cellSnapshot!.center = center
                
                if ((indexPath != nil) && (indexPath != Path.initialIndexPath)) {
                    //itemsArray.insert(itemsArray.remove(at: Path.initialIndexPath!.row), at: indexPath!.row)
                    mainCollectionView.moveItem(at: Path.initialIndexPath! as IndexPath, to: indexPath!)
                    Path.initialIndexPath = indexPath as IndexPath?
                }
            }
        default:
            if Path.initialIndexPath != nil {
                let cell = mainCollectionView.cellForItem(at: Path.initialIndexPath! as IndexPath) as UICollectionViewCell!
                if My.cellIsAnimating {
                    My.cellNeedToShow = true
                } else {
                    cell?.isHidden = false
                    cell?.alpha = 0.0
                }
                
                UIView.animate(withDuration: 0.25, animations: { () -> Void in
                    My.cellSnapshot!.center = (cell?.center)!
                    My.cellSnapshot!.transform = .identity
                    My.cellSnapshot!.alpha = 0.0
                    cell?.alpha = 1.0
                    
                }, completion: { (finished) -> Void in
                    if finished {
                        Path.initialIndexPath = nil
                        My.cellSnapshot!.removeFromSuperview()
                        My.cellSnapshot = nil
                        //self.collectionView.reloadData()
                    }
                })
            }
        }
    }
    
    func snapshotOfCell(inputView: UIView) -> UIView {
        UIGraphicsBeginImageContextWithOptions(inputView.bounds.size, false, 0.0)
        inputView.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()! as UIImage
        UIGraphicsEndImageContext()
        
        let cellSnapshot : UIView = UIImageView(image: image)
        cellSnapshot.layer.masksToBounds = false
        cellSnapshot.layer.cornerRadius = 0.0
        cellSnapshot.layer.shadowOffset =  CGSize(width: -5.0, height: 0.0)//CGSizeMake(-5.0, 0.0)
        cellSnapshot.layer.shadowRadius = 5.0
        cellSnapshot.layer.shadowOpacity = 0.4
        return cellSnapshot
    }
    

    func layoutInit(){
        let layout = mainCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.sectionInset = UIEdgeInsetsMake(0,27.multiplyWidthRatio(),0,27.multiplyWidthRatio())
        layout.itemSize = CGSize(width: 60.multiplyWidthRatio() , height: 80.multiplyHeightRatio())
        layout.minimumLineSpacing = 27.multiplyWidthRatio()
        layout.scrollDirection = .horizontal
    }
    
    func appClick(_ sender: UIButton){
        
        let appname = apps[sender.tag]!.name
        switch appname {
        case "지도":
            performSegue(withIdentifier: "mapSegue", sender: self)
            break
        case "시계":
            performSegue(withIdentifier: "clockSegue", sender: self)
            break
        default:
            break
        }
    }
    
    func appButtonLongClick(){
        for i in 0..<appButtons.count{
            startWiggle(for: appButtons[i])
        }
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
        let appCountInPage = appsCount[section]
        
        switch section {
        case 0:
            if indexPath.item < appCountInPage {
                cell.appIcon.layer.masksToBounds = true
                cell.appIcon.layer.cornerRadius = 11.multiplyWidthRatio()
                cell.appIcon.rframe(x: 0, y: 0, width: 60, height: 60)
                cell.appIcon.setImage(apps[(indexPath.item)]?.icon, for: .normal)
                cell.appIcon.tag = indexPath.item
                cell.appIcon.addTarget(self, action: #selector(appClick), for: .touchUpInside)
                cell.appIcon.addLongAction(target: self, action: #selector(appButtonLongClick))
                
                appButtons.append(cell.appIcon)
                
                cell.appName.rframe(x: 0, y: 60, width: 60, height: 20)
                cell.appName.setLabel(text: "\(apps[indexPath.item]!.name)\(indexPath.item)", align: .center, fontSize: 12, color:UIColor.white)
            } else{
                cell.appIcon.setImage(nil, for: .normal)
                cell.appName.text = "\(indexPath.item)"
            }
        default:
            if indexPath.item < appCountInPage {
                
                var count = 0
                for i in 0..<section{
                    count += appsCount[i]
                }
                
                cell.appIcon.layer.masksToBounds = true
                cell.appIcon.layer.cornerRadius = 11.multiplyWidthRatio()
                cell.appIcon.rframe(x: 0, y: 0, width: 60, height: 60)
                cell.appIcon.setImage(apps[count + indexPath.item]?.icon, for: .normal)
                cell.appIcon.tag = count + indexPath.item
                cell.appIcon.addTarget(self, action: #selector(appClick), for: .touchUpInside)
                cell.appIcon.addLongAction(target: self, action: #selector(appButtonLongClick))

                appButtons.append(cell.appIcon)
                
                cell.appName.rframe(x: 0, y: 60, width: 60, height: 20)
                cell.appName.setLabel(text: "\(apps[count + indexPath.item]!.name)\(indexPath.item)", align: .center, fontSize: 12, color:UIColor.white)
            } else{
                cell.appIcon.setImage(nil, for: .normal)
                cell.appName.text = "\(indexPath.item)"
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //
        collectionView.deselectItem(at: indexPath, animated: false)
    }

}
