//
//  CustomSegue.swift
//  again2007project
//
//  Created by 윤민섭 on 2017. 5. 26..
//  Copyright © 2017년 윤민섭. All rights reserved.
//

import UIKit

class CustomSegue: UIStoryboardSegue {

    override func perform() {
        
        let toViewController = self.destination
        let fromViewController = self.source
        
        let containerView = fromViewController.view.superview
        
        let fakeView = UIView()
        fakeView.frame = toViewController.view.frame
        fakeView.layer.contents = UIImage(named: "background")?.cgImage

        toViewController.view.center = CGPoint(x: HomeVC.homeTouchLocation.x, y: HomeVC.homeTouchLocation.y)
        
        toViewController.view.transform = CGAffineTransform(scaleX: 0, y: 0)
        fromViewController.view.addSubview(fakeView)
        
        containerView?.addSubview(toViewController.view)
        
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations: {
            toViewController.view.transform = CGAffineTransform.identity
            toViewController.view.center = CGPoint(x: UIScreen.main.bounds.width/2, y: UIScreen.main.bounds.height/2)
            
        }) { (success) in
            fakeView.removeFromSuperview()
            fromViewController.present(toViewController, animated: false, completion: nil)
        }
    }
}
