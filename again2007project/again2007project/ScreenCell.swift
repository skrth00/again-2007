//
//  ScreenCell.swift
//  again2007project
//
//  Created by 윤민섭 on 2017. 5. 25..
//  Copyright © 2017년 윤민섭. All rights reserved.
//

import UIKit

class ScreenCell: UICollectionViewCell {
    
    var appIcon = UIButton()
    var appName = UILabel()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.addSubview(appIcon)
        self.contentView.addSubview(appName)
    }
    
}
