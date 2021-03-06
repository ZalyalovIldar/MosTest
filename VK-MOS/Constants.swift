//
//  Constants.swift
//  VK-MOS
//
//  Created by Ildar Zalyalov on 20.01.17.
//  Copyright © 2017 com.personal.ildar. All rights reserved.
//

import Foundation
import UIKit

// Logger needed for debuggin
var Logger: XCGLogger {return XCGLogger.default}
// BDRealm 
var BDRealm: Realm? {return try? Realm()}
// URL for authontication using webView
let VKAuthURL:URL = "https://oauth.vk.com/authorize?client_id=5834912&scope=friends,offline,wall&DISPLAY=touch&REDIRECT_URI=http://oauth.vk.com/blank.html&response_type=token".fs_toURL()!


/*--------------User Defaults keys-------------*/
enum VKUserDefaultsKey {
    
}

/*----------Notifications---------*/
enum VKNotification {
    
}

/*----------Colors----------*/
enum AppColors
{
    static let MainColor = UIColor(fs_hexString: "224d71")
    static let BlackGrayColor = UIColor(fs_hexString: "2D343C")
}

/*----------Helpers----------*/
private func GenerateKey (_ prefix: String, key: String) -> String {
    return "__\(prefix)-\(key)__"
}

/*----------Storyboards----------*/

enum Storyboard {
    
    case login
    case customLaunchScreen
    case newsWall
    
    var name: String {
        switch self {
        case .login                : return  "Login"
        case .customLaunchScreen   : return  "CustomLaunchScreen"
        case .newsWall             : return "News"
        }
    }
    
    var storyboard: UIStoryboard {
        return UIStoryboard(name: self.name, bundle: nil)
    }
    
    var firstController: UIViewController? {
        return self.storyboard.instantiateInitialViewController()
    }
}

