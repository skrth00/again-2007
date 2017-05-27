//
//  ScreenCell.swift
//  again2007project
//
//  Created by 윤민섭 on 2017. 5. 25..
//  Copyright © 2017년 윤민섭. All rights reserved.
//

import UIKit

class ScreenCell: UICollectionViewCell {
    
    @IBOutlet weak var appIcon: UIButton!
    @IBOutlet weak var appName: UILabel!
    @IBOutlet weak var appDelete: UIButton!
    
 
    var isEditting : Bool = false {
        willSet(newValue){
            if newValue{
                startWiggle(for: appIcon)
                startWiggle(for: appDelete)
                appDelete.isHidden = false
                //삭제 아이콘 나타나기
            } else{
                stopWiggle(for: appIcon)
                stopWiggle(for: appDelete)
                appDelete.isHidden = true
            }
        }
    }
    
  
}
