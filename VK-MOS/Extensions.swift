//
//  Extensions.swift
//  VK-MOS
//
//  Created by Ildar Zalyalov on 20.01.17.
//  Copyright © 2017 com.personal.ildar. All rights reserved.
//

import Foundation

extension UIAlertController{
    /// help presend controller on Top window
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
    
    /// help presend Only one alert in cases such as Requests when response from server can triger alert showing few times
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

extension HTTPCookieStorage{
    /// Using to provide "Log Off" illusion for user
    static func removeCookies(){
        let storage = self.shared
        storage.cookies?.forEach{storage.deleteCookie($0)}
    }
}

extension Date {
    /// Help getting time interval from Date
    func getElapsedInterval() -> String {
        
        let interval = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: self, to: Date())
        
        if let year = interval.year, year > 0 {
            return year == 1 ? "\(year)" + " " + "year ago" :
                "\(year)" + " " + "years ago"
        } else if let month = interval.month, month > 0 {
            return month == 1 ? "\(month)" + " " + "month ago" :
                "\(month)" + " " + "months ago"
        } else if let day = interval.day, day > 0 {
            return day == 1 ? "\(day)" + " " + "day ago" :
                "\(day)" + " " + "days ago"
        } else if let hour = interval.hour, hour > 0{
            return hour == 1 ? "\(hour)" + " " + "hour ago" :
                "\(hour)" + " " + "hours ago"
        } else if let minute = interval.minute, minute > 0{
            return minute == 1 ? "\(minute)" + " " + "minute ago" :
                "\(minute)" + " " + "minutes ago"
        } else{
            return "a moment ago"
        }
        
    }
}

