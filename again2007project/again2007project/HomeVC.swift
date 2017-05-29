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
import MessageUI
import ContactsUI

class HomeVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CNContactPickerDelegate {
    
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
    
    static var homeTouchLocation : CGPoint!
    
    
    // main collection view
    @IBOutlet weak var mainCollectionView: UICollectionView!
    
    // editing mode
    override var isEditing: Bool {
        
        willSet(newValue) {
            let visibleCells = mainCollectionView.visibleCells
            for i in 0..<visibleCells.count{
                let cell = mainCollectionView.visibleCells[i] as! AppCell
                if cell.appIcon.image != nil{
                    cell.isEditting = newValue
                }
            }
        }
    }
    
    // app dismiss state
    var appDismissState :Bool = false
    
    // for multitasking
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var apps : [App?] = [
        .calendar,
        .maps,
        .clock,
        .camera,
        .photo,
        .calculator,
        .mamago,
        .mail,
        .weather,
        .memo,
        .message,
        .reminder,
        .video,
        .stock,
        .passbook,
        .compass,
        .newsstand,
        .settings,
        .contacts,
        .music,
        .facetime,
        .safari,
        .appStore,
        .gameCenter,
        .iTunes,
        .phone,
        ]
    
    var docApps : [App?] = [
        .phone,
        .message,
        .contacts,
        .safari,
    ]
    
    var appsCount: [Int] = [10, 8, 8]

    
    func appIndex(for indexPath: IndexPath) -> Int? {
        if indexPath.item < appsCount[indexPath.section] {
            var count = 0
            for i in 0..<indexPath.section {
                count += appsCount[i]
            }
            return count + indexPath.item
        }
        return nil
    }
    
    func appItem(for indexPath: IndexPath) -> App? {
        if let index = appIndex(for: indexPath) {
            return apps[index]
        }
        return nil
    }
    
    var newMedia: Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 배경화면
        self.view.layer.contents = UIImage(named: "background")?.cgImage
        
        layoutInit()
        setHomeBtn()

        let longpress = UILongPressGestureRecognizer(target: self, action: #selector(longPressGestureRecognized))
        mainCollectionView.addGestureRecognizer(longpress)
        
        addParallaxToView(vw: view)
        
        pageControl = UIPageControl()
        pageControl.rcenter(y: 552, width: 375, height: 10, targetWidth: 375)
        pageControl.tintColor = UIColor.lightGray
        pageControl.currentPage = 0
        pageControl.numberOfPages = appsCount.count
        self.view.addSubview(pageControl)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if appDismissState {
            self.mainCollectionView.frame = CGRect(x: 100 + (375.multiplyWidthRatio() * CGFloat(pageControl.currentPage)), y: -50, width: 0, height: 0)
            UIView.animate(withDuration: 0.05, delay: 0, options: .curveEaseInOut, animations: {
                self.mainCollectionView.rframe(x: 0, y: 30, width: 375, height: 507)
                self.mainCollectionView.contentOffset.x = 375.multiplyWidthRatio() * CGFloat(self.pageControl.currentPage)
            }) { (success) in
                self.appDismissState = false
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        UIApplication.shared.keyWindow?.addSubview(homeBtn!) // home버튼 최상위뷰에 등록
    }
    
    @IBAction func exit(_ sender: UIStoryboardSegue) {
        // noop.
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

    //single tap Action
    func singleTapDetected() {
        if HomeModel.shared.appIsRunning {
            dismissWithAnimation()
            HomeModel.shared.appIsRunning = false
        }else{
            UIView.animate(withDuration: 0.3) {
                self.mainCollectionView.contentOffset.x = 0
            }
            HomeModel.shared.appIsRunning = false
        }
        
        print("Imageview Clicked")

        if !(presentedViewController is SwitcherViewController) {
            //saveCurrentExcutedApp()
        }
        presentedViewController?.dismiss(animated: false, completion: nil)
        
        self.isEditing = false
    }
    
    //double tap Action
    func doubleTapDetected() {
        if presentedViewController is SwitcherViewController {
            presentedViewController?.dismiss(animated: true, completion: nil)
        } else {
            let storyboard = UIStoryboard(name: "Switcher", bundle: nil)
            let switcher = storyboard.instantiateInitialViewController() as! SwitcherViewController
            switcher.didClickApp = { app in
                self.dismiss(animated: false, completion: {
                    HomeModel.shared.executedApp = app
                    app?.execute()
                })
            }
            
            if presentedViewController != nil {
                self.saveCurrentExcutedApp()
                self.dismiss(animated: false, completion: {
                    self.present(switcher, animated: true, completion: nil)
                })
            } else {
                HomeModel.shared.homeScreenshot = UIImage(view: view)
                self.present(switcher, animated: true, completion: nil)
            }
            
        }
    }

    // save a current executed app screen shot to the array in the appdelegate
    func saveCurrentExcutedApp() {
        let screenImg = UIImage(view: (presentedViewController?.view)!)
        if let app = HomeModel.shared.executedApp {
            HomeModel.shared.saveScreenshot(image: screenImg, for: app)
            HomeModel.shared.updateHistory(app)
        }
//        
//        
//        let arr = NSArray(objects: HomeModel.shared.executedApp!, screenImg)
//        if appDelegate.screensArray.count == 1 {
//            appDelegate.screensArray.insert(arr, at: appDelegate.screensArray.count - 1)
//        } else {
//            for i in 0..<appDelegate.screensArray.count - 1 {
//                let temp = appDelegate.screensArray.object(at: i) as! NSArray
//                let previous = temp.object(at: 0) as! (icon: UIImage, name: String)
//                if HomeModel.shared.executedApp?.name == previous.name {
//                    appDelegate.screensArray.removeObject(at: i)
//                    appDelegate.screensArray.insert(arr, at: appDelegate.screensArray.count - 1)
//                    presentedViewController?.dismiss(animated: false, completion: nil)
//                    return
//                }
//            }
//            appDelegate.screensArray.insert(arr, at: appDelegate.screensArray.count - 1)
//        }
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
                
                if let indexPath = indexPath{
                    let cell = mainCollectionView.cellForItem(at: indexPath) as UICollectionViewCell!
                
                    if (cell?.center.x)! - 5 <= center.x ,center.x <= (cell?.center.x)!+5,
                        (cell?.center.y)! - 5 <= center.y ,center.y <= (cell?.center.y)!+5,
                        !isEnlarged{
                       
                        cell?.layer.borderWidth = 100
                        cell?.layer.cornerRadius = 15
                        cell?.layer.borderColor = UIColor.lightGray.cgColor.copy(alpha: 0.8)
                        
                        isEnlarged = true
                        
                        
                        let item = mainCollectionView.cellForItem(at: indexPath)!
                        item.layer.removeAllAnimations()
                        
                        self.lastDirCellIdx = indexPath
                        
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
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
                            //cell?.contentView.layer.borderWidth = 0
                            cell?.layer.borderWidth = 0
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                
                                if item.frame.contains(longPress.location(in: self.mainCollectionView)) == false {
                                    self.makeSmallCellSize()
                                    self.mainCollectionView.moveItem(at: Path.initialIndexPath! as IndexPath, to: indexPath)
                                    print(Path.initialIndexPath)
                                    
                                }
                            }
                            
                            
                        })
                        
                        }
        
                        
                        
                    }else{
                        

                    }
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
        if let layout = mainCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            let col = CGFloat(4)
            let spacing = (mainCollectionView.bounds.width - (60 * col)) / (col + 1)
            layout.minimumLineSpacing = spacing
            layout.minimumInteritemSpacing = 5
            layout.sectionInset = UIEdgeInsets(top: 7, left: spacing, bottom: 0, right: spacing)
        }
    }
    
    func executePhone() {
        let url = NSURL(string: "tel://1588-3830")!
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url as URL)
        } else {
            UIApplication.shared.openURL(url as URL)
        }
        print("=== 시뮬레이터에선 작업을 할 수 없습니다.===")
    }
    
    func executeMessage() {
        if MFMessageComposeViewController.canSendText() {
            let view = MFMessageComposeViewController()
            view.body = "Again 2007! 화이팅!"
            view.recipients = ["1588-3830"]
            present(view, animated: false, completion: { _ in })
        } else{
            print("=== 시뮬레이터에선 작업을 할 수 없습니다.===")
        }
    }
    
    func executeCamera() {
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
            // UIImagePickerController 인스턴스를 생성하고 cameraViewController를 객체의 델리게이트로 설정
            let imagePicker = UIImagePickerController()
            
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera           // 미디어 소스는 카메라로 정의
            imagePicker.mediaTypes = [kUTTypeImage as NSString as String]               // 동영상은 지원하지 않으므로 사진으로만 설정
            imagePicker.allowsEditing = false
            //imagePicker.showsCameraControls = true
            //imagePicker.
            
            self.present(imagePicker, animated: false, completion: nil)
            newMedia = true     // 이 사진이 새로 만들어진 것이며 카메라 롤에 있던 사진이 아님을 공지
        }
    }
    
    func executePhoto(){
        
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
        
        present(imagePickerController, animated: false, completion: nil)
        
    }
    
    func executeContacts(){
        let contactPicker = CNContactPickerViewController()
        contactPicker.delegate = self
        contactPicker.displayedPropertyKeys = [CNContactPhoneNumbersKey]
        
        self.present(contactPicker, animated: false, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        // The info dictionary contains multiple representations of the image, and this uses the original.
        let selectedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        
        // Dismiss the picker.
        dismiss(animated: false, completion: nil)
        
        
        
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

extension HomeVC: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return appsCount.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 24
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath as IndexPath) as! AppCell
        
        let app = appItem(for: indexPath)
        cell.appIcon.image = app?.icon
        cell.appName.text = app?.name
        cell.appDelete.tag = appIndex(for: indexPath) ?? -1
        cell.appDelete.addTarget(self, action: #selector(deleteAction), for: .touchUpInside)
        cell.appDelete.isHidden = true

        
        return cell
    }
}

extension HomeVC: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let app = appItem(for: indexPath) {
            HomeModel.shared.executedApp = app
            HomeModel.shared.appIsRunning = true
            app.execute()
        }
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
    
    func dismissWithAnimation(){
        self.presentedViewController?.dismiss(animated: false, completion: {

        })
    }
}

extension UIImage {
    convenience init(view: UIView) {
        UIGraphicsBeginImageContext(view.frame.size)
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.init(cgImage: (image?.cgImage)!)
    }
}

extension NSObject {
    var className: String {
        return String(describing: type(of: self)).components(separatedBy: ".").last!
    }
    
    class var className: String {
        return String(describing: self).components(separatedBy: ".").last!
    }
}

