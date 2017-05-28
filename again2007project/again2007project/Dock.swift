//
//  Dock.swift
//  again2007project
//
//  Created by red282 on 2017. 5. 28..
//  Copyright © 2017년 윤민섭. All rights reserved.
//

import UIKit

class DockViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var apps: [[App]] = [[.phone, .message, .contacts, .safari]]
    
    func items(in section: Int) -> [App] {
        return apps[section]
    }
    
    func item(at indexPath: IndexPath) -> App? {
        return items(in: indexPath.section)[indexPath.item]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            let col = CGFloat(4)
            let spacing = (collectionView.bounds.width - (60 * col)) / (col + 1)
            layout.minimumLineSpacing = spacing
            layout.minimumInteritemSpacing = 5
            layout.sectionInset = UIEdgeInsets(top: 7, left: spacing, bottom: 0, right: spacing)
        }
    }
}

extension DockViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return apps.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items(in: section).count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! AppCell
        let app = item(at: indexPath)
        cell.appIcon.image = app?.icon
        cell.appName.text = app?.name
        cell.appDelete.isHidden = !isEditing
        return cell
    }
}

extension DockViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let app = item(at: indexPath) {
            app.execute()
            HomeModel.shared.executedApp = app
            HomeModel.shared.appIsRunning = true
        }
    }
}
