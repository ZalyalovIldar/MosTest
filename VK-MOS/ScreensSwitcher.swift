//
//  ScreensSwitcher.swift
//  VK-MOS
//
//  Created by Ildar Zalyalov on 22.01.17.
//  Copyright © 2017 com.personal.ildar. All rights reserved.
//

import Foundation

// Class Helps to switch from LogIn screen to NewsWall screen

class ScreensSwithcer: NSObject {
    class func switchScreens(){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate,
            let window = appDelegate.window else {return}
        
        if BDRealm?.objects(MainUser.self).first?.token != nil{
            window.rootViewController = Storyboard.newsWall.firstController!
        }else {
            window.rootViewController = Storyboard.login.firstController!
        }
    }
}
