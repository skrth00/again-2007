//
//  SwitcherViewController.swift
//  again2007project
//
//  Created by 이승희 on 26/05/2017.
//  Copyright © 2017 윤민섭. All rights reserved.
//

import UIKit

class SwitcherViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var customCellArray:NSMutableArray = NSMutableArray()
    
    @IBOutlet weak var screenCollectionView: UICollectionView!
    
    var didClickApp: (_ name: String) -> () = { _ in}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initViewArray()
        
        let screenSize = UIScreen.main.bounds
        screenCollectionView.register(CustomCollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        let screenCollectionViewFlowLayout = screenCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        
        screenCollectionViewFlowLayout.itemSize = CGSize(width: screenSize.width / 2, height: screenSize.height / 2 + 50)
        
        screenCollectionViewFlowLayout.minimumInteritemSpacing = 0.0
        screenCollectionViewFlowLayout.minimumLineSpacing = 20
        
        let screenSectionInset = screenSize.width / 4
        screenCollectionViewFlowLayout.sectionInset = UIEdgeInsetsMake(0, screenSectionInset, 0, screenSectionInset)
        
        if customCellArray.count > 2 {
            screenCollectionView.selectItem(at: IndexPath(item: customCellArray.count - 2, section: 0), animated: false, scrollPosition: .centeredHorizontally)
        }
        
    }
    
    func initViewArray() {
        for i in 0..<appDelegate.screensArray.count {
            let tempCell = CustomCollectionViewCell.init(frame: CGRect.init(x: 0, y: 0, width: self.view.frame.width / 2, height: self.view.frame.height / 2 + 50))
            if i == appDelegate.screensArray.count - 1 {
                tempCell.screenView.image = appDelegate.screensArray.object(at: i) as? UIImage
                tempCell.titleLabel.isHidden = true
                tempCell.appImage.isHidden = true
            } else {
                let imgArr = appDelegate.screensArray.object(at: i) as? NSArray
                let app = imgArr?.object(at: 0) as! (icon: UIImage, name: String)
                tempCell.titleLabel.text = app.name
                tempCell.appImage.image = app.icon
                tempCell.screenView.image = imgArr?.object(at: 1) as? UIImage
            }
            customCellArray.add(tempCell)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return customCellArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "screen", for: indexPath)
        
        let tempCell = customCellArray.object(at: indexPath.row) as! CustomCollectionViewCell
        
        cell.addSubview(tempCell.contentView)
        
        let UpSwipe = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture) )
        UpSwipe.direction = UISwipeGestureRecognizerDirection.up
        cell.addGestureRecognizer(UpSwipe)
        
        return cell
    }
    
    func respondToSwipeGesture(sender: UISwipeGestureRecognizer) {
        let cell = sender.view as! UICollectionViewCell
        let i = screenCollectionView.indexPath(for: cell)?.item
        if i! < appDelegate.screensArray.count - 1 {
            appDelegate.screensArray.removeObject(at: i!)
        }
        
        customCellArray.removeAllObjects()
        self.initViewArray()
        let origin = cell.frame
        UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseOut, animations: {
            var basketTopFrame = cell.frame
            basketTopFrame.origin.y -= basketTopFrame.size.height
            cell.frame = basketTopFrame
        }, completion: { finished in
            if i! == self.appDelegate.screensArray.count - 1 {
                cell.frame = origin
            } else {
                self.screenCollectionView.deleteItems(at: [IndexPath(item: i!, section: 0)])
            }
            self.screenCollectionView.reloadData()
            
        })
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == self.customCellArray.count - 1 {
            removeAnimate()
        } else {
            let temp = appDelegate.screensArray.object(at: indexPath.row) as! NSArray
            let app = temp.object(at: 0) as! (icon: UIImage, name: String)
            self.didClickApp(app.name)
        }
    }
    
    func removeAnimate() {
        UIView.animate(withDuration: 0.35, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            self.view.alpha = 0.0
        }, completion: { (finished : Bool) in
            if (finished) {
                self.dismiss(animated: false, completion: nil)
            }
            
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
}
