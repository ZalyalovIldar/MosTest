//
//  Constants.swift
//  VK-MOS
//
//  Created by Ildar Zalyalov on 20.01.17.
//  Copyright © 2017 com.personal.ildar. All rights reserved.
//

import Foundation
import UIKit

/*--------------User Defaults keys-------------*/
enum FSUserDefaultsKey {
    
}

/*----------Notifications---------*/
enum FSNotification {
    
}

/*----------Colors----------*/

/*----------Helpers----------*/
private func GenerateKey (_ prefix: String, key: String) -> String {
    return "__\(prefix)-\(key)__"
}

/*----------Storyboards----------*/

enum Storyboard {
    
    case login
    case welcome
    case newsWall
    
    var name: String {
        switch self {
        case .login     : return  "Login"
        case .welcome   : return  "WelcomeScreen"
        case .newsWall   : return "News"
        }
    }
    
    var storyboard: UIStoryboard {
        return UIStoryboard(name: self.name, bundle: nil)
    }
    
    var firstController: UIViewController? {
        return self.storyboard.instantiateInitialViewController()
    }
}

