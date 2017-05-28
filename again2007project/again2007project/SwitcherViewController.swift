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
    var customCellArray: [UICollectionViewCell] = []
    
    @IBOutlet weak var screenCollectionView: UICollectionView!
    
    var didClickApp: ((App?) -> Void) = { _ in}
    
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
        customCellArray = HomeModel.shared.screenshots.map {
            let cell = CustomCollectionViewCell(frame: CGRect(x: 0, y: 0, width: view.frame.width / 2, height: view.frame.height / 2 + 50))
            cell.titleLabel.text = $0.name
            cell.appImage.image = $0.icon
            cell.screenView.image = $1
            return cell
        }
        
        let homeCell = CustomCollectionViewCell(frame: CGRect(x: 0, y: 0, width: view.frame.width / 2, height: view.frame.height / 2 + 50))
        homeCell.screenView.image = HomeModel.shared.homeScreenshot
        homeCell.titleLabel.isHidden = true
        homeCell.appImage.isHidden = true
        customCellArray.append(homeCell)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return customCellArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "screen", for: indexPath)
        
        let tempCell = customCellArray[indexPath.item] as! CustomCollectionViewCell
        
        cell.addSubview(tempCell.contentView)
        
        let UpSwipe = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture) )
        UpSwipe.direction = UISwipeGestureRecognizerDirection.up
        cell.addGestureRecognizer(UpSwipe)
        
        return cell
    }
    
    func respondToSwipeGesture(sender: UISwipeGestureRecognizer) {
        let cell = sender.view as! UICollectionViewCell
        let i = screenCollectionView.indexPath(for: cell)!.item
        
        let app = HomeModel.shared.app(at: i)
        HomeModel.shared.deleteHistory(app)
        
        customCellArray.removeAll()
        initViewArray()
        let origin = cell.frame
        UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseOut, animations: {
            var basketTopFrame = cell.frame
            basketTopFrame.origin.y -= basketTopFrame.size.height
            cell.frame = basketTopFrame
        }, completion: { finished in
            if i == HomeModel.shared.history.count - 1 {
                cell.frame = origin
            } else {
                self.screenCollectionView.deleteItems(at: [IndexPath(item: i, section: 0)])
            }
            self.screenCollectionView.reloadData()
            
        })
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == self.customCellArray.count - 1 {
            removeAnimate()
        } else {
            let app = HomeModel.shared.app(at: indexPath.item)
            didClickApp(app)
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
}
