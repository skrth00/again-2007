//
//  ViewController.swift
//  again2007project
//
//  Created by 윤민섭 on 2017. 5. 25..
//  Copyright © 2017년 윤민섭. All rights reserved.
//

import UIKit
import DORM
import MobileCoreServices

class HomeVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    var homeBtn: UIImageView?
    var viewControllerList = [UIViewController]()
    
    var pageControl: UIPageControl!
    var initialContentOffset = CGPoint()
    
    // directory
    var isTapped = false
    var lastDirCellIdx : IndexPath?
    var isEnlarged = false
    var isEnlargeEnd = false
    let blurEffectView = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffectStyle.regular))
    
    
    // main collection view
    @IBOutlet weak var mainCollectionView: UICollectionView!
    
    // editing mode
    override var isEditing: Bool {
        
        willSet(newValue) {
            let visibleCells = mainCollectionView.visibleCells
            for i in 0..<visibleCells.count{
                let cell = mainCollectionView.visibleCells[i] as! ScreenCell
                cell.isEditting = newValue
            }
        }
    }
    
//<<<<<<< Updated upstream
    var apps : [(icon: UIImage, name: String)?] = [(icon: #imageLiteral(resourceName: "캘린더"), name: "캘린더"),
                                                   (icon: #imageLiteral(resourceName: "지도"), name: "지도"),
                                                   (icon: #imageLiteral(resourceName: "시계"), name: "시계"),
                                                   (icon: #imageLiteral(resourceName: "카메라"), name: "카메라"),
                                                   (icon: #imageLiteral(resourceName: "사진"), name: "사진"),
                                                   (icon: #imageLiteral(resourceName: "계산기"), name: "계산기"),
                                                   (icon: #imageLiteral(resourceName: "메일"), name: "메일"),
                                                   (icon: #imageLiteral(resourceName: "날씨"), name: "날씨"),
                                                   (icon: #imageLiteral(resourceName: "메모"), name: "메모"),
                                                   (icon: #imageLiteral(resourceName: "메시지"), name: "메시지"),
                                                   (icon: #imageLiteral(resourceName: "미리알림"), name: "미리알림"),
                                                   (icon: #imageLiteral(resourceName: "비디오"), name: "비디오"),
                                                   (icon: #imageLiteral(resourceName: "주식"), name: "주식"),
                                                   (icon: #imageLiteral(resourceName: "지도"), name: "지도"),
                                                   (icon: #imageLiteral(resourceName: "papago"), name: "마마고"),
                                                   (icon: #imageLiteral(resourceName: "Passbook"), name: "Passbook"),
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
                                                   (icon: #imageLiteral(resourceName: "itunes"), name: "iTunes"),
                                                   (icon: #imageLiteral(resourceName: "safari"), name: "Safari"),
                                                   ]
    var appsCount: [Int] = [10, 8, 8]

    
    var appButtons : [UIButton] = []
    
    var newMedia: Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 배경화면
        self.view.layer.contents = UIImage(named: "background")?.cgImage
        
        layoutInit()
        viewInit()
        setHomeBtn()
        let longpress = UILongPressGestureRecognizer(target: self, action: #selector(longPressGestureRecognized))
        mainCollectionView.addGestureRecognizer(longpress)
        
        addParallaxToView(vw: view)
        dockerViewInit()
        
        pageControl = UIPageControl()
        pageControl.rcenter(y: 552, width: 375, height: 10, targetWidth: 375)
        pageControl.tintColor = UIColor.lightGray
        pageControl.currentPage = 0
        pageControl.numberOfPages = appsCount.count
        self.view.addSubview(pageControl)
        
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
    func dockerViewInit(){
        
        let bottomView = UIView()
        bottomView.rframe(x: 0, y: 570, width: 375, height: 97)
        bottomView.backgroundColor = UIColor.init(red: 245/255, green: 245/255, blue: 245/255, alpha: 0.6)
        
        let appIcon1 = UIButton()
        appIcon1.rframe(x: 27, y: 15, width: 60, height: 60)
        appIcon1.setImage(apps[17]?.icon, for: .normal)
        
        let appName1 = UILabel()
        appName1.rframe(x: 27, y: 75, width: 60, height: 20)
        appName1.setLabel(text: "\(apps[17]!.name)", align: .center, fontSize: 12, color:UIColor.white)
        
        let appIcon2 = UIButton()
        appIcon2.rframe(x: 114, y: 15, width: 60, height: 60)
        appIcon2.setImage(apps[9]?.icon, for: .normal)
        
        let appName2 = UILabel()
        appName2.rframe(x: 114, y: 75, width: 60, height: 20)
        appName2.setLabel(text: "\(apps[9]!.name)", align: .center, fontSize: 12, color:UIColor.white)
        
        let appIcon3 = UIButton()
        appIcon3.rframe(x: 201, y: 15, width: 60, height: 60)
        appIcon3.setImage(apps[24]?.icon, for: .normal)
        
        let appName3 = UILabel()
        appName3.rframe(x: 201, y: 75, width: 60, height: 20)
        appName3.setLabel(text: "\(apps[24]!.name)", align: .center, fontSize: 12, color:UIColor.white)
        
        let appIcon4 = UIButton()
        appIcon4.rframe(x: 288, y: 15, width: 60, height: 60)
        appIcon4.setImage(apps[23]?.icon, for: .normal)
        
        let appName4 = UILabel()
        appName4.rframe(x: 288, y: 75, width: 60, height: 20)
        appName4.setLabel(text: "\(apps[23]!.name)", align: .center, fontSize: 12, color:UIColor.white)
        
        
        
        view.addSubview(bottomView)
        bottomView.addSubview(appIcon1)
        bottomView.addSubview(appName1)
        bottomView.addSubview(appIcon2)
        bottomView.addSubview(appName2)
        bottomView.addSubview(appIcon3)
        bottomView.addSubview(appName3)
        bottomView.addSubview(appIcon4)
        bottomView.addSubview(appName4)
    
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        UIApplication.shared.keyWindow?.addSubview(homeBtn!) // home버튼 최상위뷰에 등록
    }
    
    func setHomeBtn(){
        let homeBtnSize:CGFloat = 50
        homeBtn = UIImageView(frame:CGRect(x: 0, y: self.view.frame.size.height - homeBtnSize, width: homeBtnSize, height:homeBtnSize))
        homeBtn?.image = #imageLiteral(resourceName: "home")
        homeBtn?.layer.cornerRadius = 25
        homeBtn?.layer.masksToBounds = true
        
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
    var appActivityStatus = false
    //single tap Action
    func singleTapDetected() {
        if appActivityStatus {
            presentedViewController?.dismiss(animated: false, completion: nil)
            appActivityStatus = false
        }else{
            UIView.animate(withDuration: 0.3) {
                self.mainCollectionView.contentOffset.x = 0
            }
            appActivityStatus = false
        }
        
        print("Imageview Clicked")
        self.isEditing = false
    }
    
    //double tap Action
    func doubleTapDetected() {
        print("Imageview double Clicked")
    }

    
    func longPressGestureRecognized(gestureRecognizer: UIGestureRecognizer) {
        self.isEditing = true
        
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
                My.cellSnapshot!.center = center
                
                if ((indexPath != nil) && (indexPath != Path.initialIndexPath) && !isEnlarged) {
                    
                    //                    let mergedItem = self.collectionView.cellForItem(at: Path.initialIndexPath!) as! UICollectionViewCell
                    //                    mergedItem.layer.removeAllAnimations()
                    print("호출, \(gestureRecognizer.view)")
                    print("[suejinv] isEnlarged true")
                    isEnlarged = true
                    //                    isEnlargeEnd = false
                    
                    let item = mainCollectionView.cellForItem(at: indexPath!)!
                    item.layer.removeAllAnimations()
                    
                    self.lastDirCellIdx = indexPath
                    
                    UIView.animate(withDuration: 1, animations: {
                        
                        self.mainCollectionView.addSubview(self.blurEffectView)
                        self.mainCollectionView.bringSubview(toFront: self.blurEffectView)
                        //self.lastDirCellIdx = indexPath
                        self.blurEffectView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.makeSmallCellSize)))
                        
                        self.mainCollectionView.bringSubview(toFront: item)
                        self.mainCollectionView.bringSubview(toFront: My.cellSnapshot!)
                        item.frame.origin = self.view.frame.origin
                        item.frame.origin.x = 40
                        item.frame.origin.y = 200
                        item.frame.size.width = self.view.frame.width - 80
                        item.frame.size.height = self.view.frame.height - 400
                        item.backgroundColor = UIColor.lightGray
                    }, completion: { (finished) -> Void in
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            
                            if item.frame.contains(longPress.location(in: self.mainCollectionView)) == false {
                                self.makeSmallCellSize()
                                self.mainCollectionView.moveItem(at: Path.initialIndexPath! as IndexPath, to: indexPath!)
                                print(Path.initialIndexPath)
                                
                            }
                        }
                        
                        
                    })
                    
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
                        //Path.initialIndexPath = nil
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
        appActivityStatus = true
        switch appname {
        case "지도":
            performSegue(withIdentifier: "mapSegue", sender: self)
            break
        case "시계":
            performSegue(withIdentifier: "clockSegue", sender: self)
            break
        case "마마고":
            performSegue(withIdentifier: "papagoSegue", sender: self)
        case "사진":
            photoLibraryAppExecuted()
            break
        case "카메라":
            cameraAppExecuted()
            break
        case "AppStore":
            performSegue(withIdentifier: "appstoreSegue", sender: self)
            break
        case "미리알림":
            performSegue(withIdentifier: "prenoticeSegue", sender: self)
            break
        case "비디오":
            performSegue(withIdentifier: "videoSegue", sender: self)
            break
        case "캘린더":
            performSegue(withIdentifier: "calenderSegue", sender: self)
            break
        case "날씨":
            performSegue(withIdentifier: "weatherSegue", sender: self)
            break
        case "설정":
            performSegue(withIdentifier: "settingSegue", sender: self)
            break
        
        default:
            break
        }
    }
    
    
    func cameraAppExecuted(){
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
            // UIImagePickerController 인스턴스를 생성하고 cameraViewController를 객체의 델리게이트로 설정
            let imagePicker = UIImagePickerController()
            
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera           // 미디어 소스는 카메라로 정의
            imagePicker.mediaTypes = [kUTTypeImage as NSString as String]               // 동영상은 지원하지 않으므로 사진으로만 설정
            imagePicker.allowsEditing = false
            //imagePicker.showsCameraControls = true
            //imagePicker.
            
            self.present(imagePicker, animated: true, completion: nil)
            newMedia = true     // 이 사진이 새로 만들어진 것이며 카메라 롤에 있던 사진이 아님을 공지
        }
    }
    
    func photoLibraryAppExecuted(){
        
        // Hide the keyboard.
        //textView.resignFirstResponder()
        
        // UIImagePickerController is a view controller that lets a user pick media from their photo library.
        let imagePickerController = UIImagePickerController()
        
        // Only allow photos to be picked, not taken.
        imagePickerController.sourceType = .photoLibrary
        
        // Make sure ViewController is notified when the user picks an image.
        imagePickerController.delegate = self
        
        imagePickerController.navigationBar.tintColor = UIColor.clear
        imagePickerController.navigationBar.isUserInteractionEnabled = false
        
        present(imagePickerController, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        // The info dictionary contains multiple representations of the image, and this uses the original.
        let selectedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        
        // Dismiss the picker.
        dismiss(animated: true, completion: nil)
        
        
        
        //
        
        let mediaType = info[UIImagePickerControllerMediaType] as! NSString
        
        //self.dismissViewControllerAnimated(true, completion: nil)
        
        if mediaType.isEqual(to: kUTTypeImage as NSString as String){
            let image = info[UIImagePickerControllerOriginalImage] as! UIImage
            //Image.image = image
            
            // 새로 찍은 이미지일 경우 앨범에 저장 처리
            if (newMedia == true) {
                UIImageWriteToSavedPhotosAlbum(image, self, nil, nil)
            }else if mediaType.isEqual(to: kUTTypeMovie as NSString as String){
                // 비디오 지원을 위한 코드
            }
        }
        
        
        
    }
    
    
    func image(_ image:UIImage, didFinishSavingWithError error:NSErrorPointer?, contextInfo:UnsafeRawPointer){
        if error != nil {
            let alert = UIAlertController(title: "Save Failed", message: "Failed to save image", preferredStyle: UIAlertControllerStyle.alert)
            let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func addParallaxToView(vw: UIView) {
        let amount = 100
        
        let horizontal = UIInterpolatingMotionEffect(keyPath: "center.x", type: .tiltAlongHorizontalAxis)
        horizontal.minimumRelativeValue = -amount
        horizontal.maximumRelativeValue = amount
        
        let vertical = UIInterpolatingMotionEffect(keyPath: "center.y", type: .tiltAlongVerticalAxis)
        vertical.minimumRelativeValue = -amount
        vertical.maximumRelativeValue = amount
        
        let group = UIMotionEffectGroup()
        group.motionEffects = [horizontal, vertical]
        vw.addMotionEffect(group)
    }

    func deleteAction(_ sender: UIButton){
        appDeleteAlert(appName: (apps[sender.tag]?.name)!, item: sender.tag)
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
                
                cell.appDelete.layer.masksToBounds = true
                cell.appDelete.layer.cornerRadius = 9.multiplyWidthRatio()
                cell.appDelete.rframe(x: 0, y: 0, width: 18, height: 18)
                cell.appDelete.setImage(#imageLiteral(resourceName: "del"), for: .normal)
                cell.appDelete.addTarget(self, action: #selector(deleteAction), for: .touchUpInside)
                cell.appDelete.tag = indexPath.item
                cell.appDelete.isHidden = true
                
                cell.appName.rframe(x: 0, y: 60, width: 60, height: 20)
                cell.appName.setLabel(text: "\(apps[indexPath.item]!.name)\(indexPath.item)", align: .center, fontSize: 12, color:UIColor.white)
            } else{
                cell.appIcon.setImage(nil, for: .normal)
                cell.appName.text = "\(indexPath.item)"
                cell.appDelete.setImage(nil, for: .normal)
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
                
                cell.appDelete.layer.masksToBounds = true
                cell.appDelete.layer.cornerRadius = 9.multiplyWidthRatio()
                cell.appDelete.rframe(x: 0, y: 0, width: 18, height: 18)
                cell.appDelete.setImage(#imageLiteral(resourceName: "del"), for: .normal)
                cell.appDelete.isHidden = true
                cell.appDelete.tag = count + indexPath.item
                cell.appDelete.addTarget(self, action: #selector(deleteAction), for: .touchUpInside)
                
                cell.appName.rframe(x: 0, y: 60, width: 60, height: 20)
                cell.appName.setLabel(text: "\(apps[count + indexPath.item]!.name)", align: .center, fontSize: 12, color:UIColor.white)
            } else{
                cell.appIcon.setImage(nil, for: .normal)
                cell.appName.text = ""
                cell.appDelete.setImage(nil, for: .normal)
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //
        collectionView.deselectItem(at: indexPath, animated: false)
    }

}

//directory
extension HomeVC {
    func makeSmallCellSize() {
        
        if let idx = lastDirCellIdx {
            let item = mainCollectionView.cellForItem(at: idx as IndexPath) as UICollectionViewCell!
            
            UIView.animate(withDuration: 1.0, animations: {
                
                item?.frame.origin = self.view.frame.origin   /// this view origin will be at the top of the scroll content, you'll have to figure this out
                item?.frame.origin.x = CGFloat(idx.row % 3) * (DeviceUtil.knowScreenWidth() / 3)
                item?.frame.origin.y = CGFloat(idx.row / 3) * (DeviceUtil.knowScreenWidth() / 3)
                item?.frame.size.width = DeviceUtil.knowScreenWidth() / 3
                item?.frame.size.height = DeviceUtil.knowScreenWidth() / 3
                
            }, completion: { (finished) -> Void in
                self.mainCollectionView.sendSubview(toBack: self.blurEffectView)
                
                NSLog("[suejinv] isEnlarged false")
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    NSLog("[suejinv] aaae")
                    self.isEnlarged = false
                }
            })
            
            
            //self.view.addSubview(blurEffectView)
            //collectionView.bringSubview(toFront: blurEffectView)
        }
    }
}

extension HomeVC{
    func appDeleteAlert(appName: String, item: Int){
        let alertView = UIAlertController(title: "`\(appName)`을(를) 삭제하겠습니까?", message: "이 앱을 삭제하면 해당 데이터도 삭제됩니다.", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "삭제", style: UIAlertActionStyle.destructive, handler: { (UIAlertAction) in
            self.apps.remove(at: item)
            self.appsCount[self.pageControl.currentPage] -= 1
            self.mainCollectionView.reloadData()
            alertView.dismiss(animated: true, completion: nil)
        })
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel) { (_) in }
        
        alertView.addAction(action)
        alertView.addAction(cancelAction)
        
        alertWindow(alertView: alertView)
    }
    
    func alertWindow(alertView: UIAlertController){
        let alertWindow = UIWindow(frame: UIScreen.main.bounds)
        alertWindow.rootViewController = UIViewController()
        alertWindow.windowLevel = UIWindowLevelAlert + 1
        alertWindow.makeKeyAndVisible()
        alertWindow.rootViewController?.present(alertView, animated: true, completion: nil)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.initialContentOffset = scrollView.contentOffset
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if mainCollectionView.contentOffset.x > self.initialContentOffset.x {
            // 오른쪽
            pageControl.currentPage += 1
        } else if mainCollectionView.contentOffset.x < self.initialContentOffset.x{
            pageControl.currentPage -= 1
        }
        
    }
    
  
}
