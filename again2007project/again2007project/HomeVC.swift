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
    
    var apps : [(icon: UIImage, name: String)?] = [(icon: UIImage(named: "pic")!, name: "사진"),(icon: UIImage(named: "camera")!, name: "카메라"),(icon: UIImage(named:"clock")!, name: "시계")]
    var appsCount: [Int] = [2,1]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 배경화면
        self.view.layer.contents = UIImage(named: "background")?.cgImage
        
        layoutInit()
        viewInit()
        
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //
        collectionView.deselectItem(at: indexPath, animated: false)
    }

}

