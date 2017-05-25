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

    
    // 메인 스크롤뷰
    var mainScrollView : UIScrollView!
    
    // 화면 리스트 ( collection view list)
    var screens : [UICollectionView] = []
    
    // collection view layout
    var layout:UICollectionViewFlowLayout!
    
    // 앱 리스트
    var app : [(icon: UIImage, name: String)] = [(icon: UIImage(named: "pic")!, name: "사진"),(icon: UIImage(named:"clock")!, name:"시계"),(icon: UIImage(named: "camera")!, name:"카메라")]
    
    // 각각의 콜렉션뷰가 소유하고있는 앱의 개수
    var appCount : [Int] = [1,2]
    
    // 앱 리스트에서 앱이 이동하면 해당 인덱스를 옮긴 화면의 끝에 넣어주고 이동 전 화면의 앱 개수 감소, 이동 후 화면의 앱 개수 증가
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 배경화면
        self.view.layer.contents = UIImage(named: "background")?.cgImage
        
        layoutInit()
        
        scrollInit()
        
        viewInit()
        
        addCollectionView()
        
    }
    
    func scrollInit(){
        
        mainScrollView = UIScrollView()
        
        // 스크롤 뷰 크기
        mainScrollView.rframe(x: 0, y: 0, width: 375, height: 547)
        
        // user interaction
        mainScrollView.isUserInteractionEnabled = true
        
        // show indicator
        mainScrollView.showsHorizontalScrollIndicator = false
        
        // 스크롤뷰 내용 크기
        mainScrollView.contentSize = CGSize(width: 0, height: 547.multiplyHeightRatio())
        
        // 페이징 가능
        mainScrollView.isPagingEnabled = true
        
        self.view.addSubview(mainScrollView)
    }
    
    func viewInit(){
        // 첫번째 화면 init
        let firstCV = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
        screens.append(firstCV)
        collectionViewInit(col: firstCV, positionX: 0)
        mainScrollView.contentSize.width += 375.multiplyWidthRatio()
        
    }
    
    func collectionViewInit(col: UICollectionView, positionX: CGFloat){
        col.backgroundColor = UIColor(white: 0, alpha: 0)
        col.rframe(x: positionX.remultiplyWidthRatio(), y: 0, width: 375, height: 547)
        col.dataSource = self
        col.delegate = self
        col.register(ScreenCell.self, forCellWithReuseIdentifier: "screenCell")
        col.isScrollEnabled = false
        mainScrollView.addSubview(col)
    }
    
    func layoutInit(){
        layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsetsMake(40.multiplyHeightRatio(), 27.multiplyWidthRatio(), 0, 27.multiplyWidthRatio())
        layout.itemSize = CGSize(width: 60.multiplyWidthRatio() , height: 80.multiplyHeightRatio())
        layout.minimumLineSpacing = 27.multiplyHeightRatio()
    }
    
    func addCollectionView(){
        let addingPage = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
        screens.append(addingPage)
        collectionViewInit(col: addingPage, positionX: mainScrollView.contentSize.width)
        mainScrollView.contentSize.width += 375.multiplyWidthRatio()
    }

}

extension HomeVC{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let collectionIndex = screens.index(of: collectionView)!
        return appCount[collectionIndex]
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "screenCell", for: indexPath as IndexPath) as! ScreenCell
        let collectionIndex = screens.index(of: collectionView)!
        let collectionAppCount = appCount[collectionIndex]
        
        cell.backgroundColor = UIColor(white: 0, alpha: 0)
        print(indexPath)
        cell.appIcon.layer.masksToBounds = true
        cell.appIcon.layer.cornerRadius = 11.multiplyWidthRatio()
        cell.appIcon.rframe(x: 0, y: 0, width: 60, height: 60)
        cell.appIcon.setImage(app[collectionAppCount + indexPath.row - 1].icon, for: .normal)
        //cell.appIcon.setImage(app[indexPath.row].icon, for: .normal)
        
        cell.appName.rframe(x: 0, y: 60, width: 60, height: 20)
        cell.appName.setLabel(text: app[collectionAppCount + indexPath.row - 1].name, align: .center, fontSize: 12, color: UIColor.white)
        //cell.appName.setLabel(text: app[indexPath.row].name, align: .center, fontSize: 12, color: UIColor.white)
        
        return cell
    }
}

