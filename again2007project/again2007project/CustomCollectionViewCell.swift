//
//  CustomCollectionViewCell.swift
//  again2007project
//
//  Created by 이승희 on 26/05/2017.
//  Copyright © 2017 윤민섭. All rights reserved.
//

import UIKit

class CustomCollectionViewCell: UICollectionViewCell {
    var screenView: UIImageView!
    var titleLabel: UILabel!
    var appImage: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        appImage = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        titleLabel = UILabel(frame: CGRect(x: appImage.frame.width + 8, y: 0, width: frame.width - appImage.frame.width - 8, height: 30))
        screenView = UIImageView(frame: CGRect(x: 0, y: appImage.frame.height + 8, width: frame.width, height: frame.height - appImage.frame.height - 8))
        
        screenView.layer.cornerRadius = 5
        screenView.layer.masksToBounds = true
        
        titleLabel.textColor = UIColor.white
        titleLabel.font = UIFont.systemFont(ofSize: 15)
        titleLabel.textAlignment = .left
        
        contentView.addSubview(appImage)
        contentView.addSubview(titleLabel)
        contentView.addSubview(screenView)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

