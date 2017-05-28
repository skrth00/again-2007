//
//  SwitcherViewController.swift
//  again2007project
//
//  Created by 이승희 on 26/05/2017.
//  Copyright © 2017 윤민섭. All rights reserved.
//

import UIKit

class SwitcherViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var history: [App] {
        return HomeModel.shared.history
    }
    
    var didClickApp: ((App?) -> Void) = { _ in}
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if history.count > 1 {
            collectionView.selectItem(at: IndexPath(item: history.count - 1, section: 0), animated: false, scrollPosition: .centeredHorizontally)
        }
    }
    
    func respondToSwipeGesture(sender: UISwipeGestureRecognizer) {
        let cell = sender.view as! UICollectionViewCell
        let indexPath = collectionView.indexPath(for: cell)!
        
        if !isHome(indexPath) {
            let app = HomeModel.shared.app(at: indexPath.item)
            HomeModel.shared.deleteHistory(app)
            
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
                cell.transform.ty = -(cell.bounds.height * 2)
                cell.alpha = 0
            }) { _ in
                self.collectionView.deleteItems(at: [indexPath])
                self.collectionView.reloadData()
            }
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
    
    func isHome(_ indexPath: IndexPath) -> Bool {
        return indexPath.item == history.count
    }
}

extension SwitcherViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return HomeModel.shared.history.count + 1 // 1 => home
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! SwitcherCell
        if isHome(indexPath) {
            cell.appScreenshot.image = HomeModel.shared.homeScreenshot
        } else {
            let app = history[indexPath.item]
            cell.appScreenshot.image = HomeModel.shared.screenshot(for: app)
            cell.appName.text = app.name
            cell.appIcon.image = app.icon
        }
        cell.appName.isHidden = isHome(indexPath)
        cell.appIcon.isHidden = isHome(indexPath)
        
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture) )
        swipe.direction = .up
        cell.addGestureRecognizer(swipe)
        
        return cell
    }
}

extension SwitcherViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if isHome(indexPath) {
            removeAnimate()
        } else {
            let app = HomeModel.shared.app(at: indexPath.item)
            didClickApp(app)
        }
    }
}

extension SwitcherViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let rate = CGFloat(0.7)
        return CGSize(width: collectionView.bounds.width * rate, height: collectionView.bounds.height * rate)
    }
}


class SwitcherCell: UICollectionViewCell {
    
    @IBOutlet weak var appIcon: UIImageView!
    @IBOutlet weak var appName: UILabel!
    @IBOutlet weak var appScreenshot: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        appScreenshot.layer.cornerRadius = 2
        appScreenshot.layer.masksToBounds = true
    }
}

