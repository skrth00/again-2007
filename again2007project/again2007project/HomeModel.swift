//
//  HomeModel.swift
//  again2007project
//
//  Created by red282 on 2017. 5. 28..
//  Copyright © 2017년 윤민섭. All rights reserved.
//

import UIKit

class HomeModel {
    
    static let shared = HomeModel()
    
    var executedApp: App?
    var appIsRunning: Bool = false
    
    var history: [App] = []
    
    func app(at index: Int) -> App {
        return history[index]
    }
    
    func updateHistory(_ app: App) {
        deleteHistory(app)
        history.append(app)
    }
    
    func deleteHistory(_ app: App) {
        if let index = history.index(of: app) {
            history.remove(at: index)
        }
    }
    
    var screenshots: [App: UIImage] = [:]
    var homeScreenshot: UIImage?
    
    func saveScreenshot(image: UIImage, for app: App) {
        screenshots[app] = image
    }
    
    func screenshot(for app: App) -> UIImage? {
        return screenshots[app]
    }
}
