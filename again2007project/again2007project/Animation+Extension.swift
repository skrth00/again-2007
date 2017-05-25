//
//  Animation+Extension.swift
//  HomeScreen
//
//  Created by 윤민섭 on 2017. 5. 24..
//  Copyright © 2017년 윤민섭. All rights reserved.
//

import UIKit

let wiggleBounceY = 3.0
let wiggleBounceDuration = 0.1
let wiggleBounceDurationVariance = 0.02

let wiggleRotateAngle = 0.03
let wiggleRotateDuration = 0.10
let wiggleRotateDurationVariance = 0.025

func randomize(interval: TimeInterval, withVariance variance: Double) -> Double{
    let random = (Double(arc4random_uniform(1000)) - 500.0) / 500.0
    return interval + variance * random
}

func startWiggle(for view: UIView){
    
    //Create rotation animation
    let rotationAnim = CAKeyframeAnimation(keyPath: "transform.rotation.z")
    rotationAnim.values = [-wiggleRotateAngle, wiggleRotateAngle]
    rotationAnim.autoreverses = true
    rotationAnim.duration = randomize(interval: wiggleRotateDuration, withVariance: wiggleRotateDurationVariance)
    rotationAnim.repeatCount = HUGE
    
    //Create bounce animation
    let bounceAnimation = CAKeyframeAnimation(keyPath: "transform.translation.y")
    bounceAnimation.values = [wiggleBounceY, 0]
    bounceAnimation.autoreverses = true
    bounceAnimation.duration = randomize(interval: wiggleBounceDuration, withVariance: wiggleBounceDurationVariance)
    bounceAnimation.repeatCount = HUGE
    
    //Apply animations to view
    UIView.animate(withDuration: 0) {
        view.layer.add(rotationAnim, forKey: "rotation")
        view.layer.add(bounceAnimation, forKey: "bounce")
        view.transform = .identity
    }
}

func stopWiggle(for view: UIView){
    view.layer.removeAllAnimations()
}
