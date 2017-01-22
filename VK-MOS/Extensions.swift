//
//  Extensions.swift
//  VK-MOS
//
//  Created by Ildar Zalyalov on 20.01.17.
//  Copyright © 2017 com.personal.ildar. All rights reserved.
//

import Foundation

extension UIAlertController{
    func presentOnModal() {
        guard   let appDelegate = UIApplication.shared.delegate as? AppDelegate,
            let window = appDelegate.window else {return}
        var presentedController = window.rootViewController
        var nextController = presentedController?.presentedViewController
        while nextController != nil  {
            presentedController = nextController
            nextController = presentedController?.presentedViewController
        }
        presentedController?.present(self, animated: true, completion: nil)
    }
    func presentIfNoAlertsPresented() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate,
            let window = appDelegate.window else {return}
        var presentedController = window.rootViewController
        var nextController = presentedController?.presentedViewController
        while nextController != nil  {
            presentedController = nextController
            nextController = presentedController?.presentedViewController
        }
        if let _ = presentedController as? UIAlertController {return}
        presentedController?.present(self, animated: true, completion: nil)
    }
}

extension UICollectionViewCell {
    static func nib() -> UINib {
        let nib = UINib(nibName: nibName(), bundle: nil)
        return nib
    }
    
    static func nibName() -> String {
        return String.init(describing: self.self)
    }
    
    static func cellIdentifier() -> String {
        return String.init(describing: self.self)
    }
    
}

extension UITableViewCell {
    static func nib() -> UINib {
        let nib = UINib(nibName: nibName(), bundle: nil)
        return nib
    }
    
    static func nibName() -> String {
        return String.init(describing: self.self)
    }
    
    static func cellIdentifier() -> String {
        return String.init(describing: self.self)
    }
    
}

