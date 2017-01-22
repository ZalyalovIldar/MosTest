//
//  ScreensSwitcher.swift
//  VK-MOS
//
//  Created by Ildar Zalyalov on 22.01.17.
//  Copyright © 2017 com.personal.ildar. All rights reserved.
//

import Foundation

class ScreensSwithcer: NSObject {
    class func switchScreens(){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate,
            let window = appDelegate.window else {return}
        
        if UserDefaults.standard.object(forKey: VKUserDefaultsKey.UserAccesToken) != nil{
            window.rootViewController = Storyboard.newsWall.firstController!
        }else {
            window.rootViewController = Storyboard.login.firstController!
        }
    }
}
