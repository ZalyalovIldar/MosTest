//
//  Alerts.swift
//  VK-MOS
//
//  Created by Ildar Zalyalov on 20.01.17.
//  Copyright © 2017 com.personal.ildar. All rights reserved.
//

import Foundation

func ShowUnauthorizedAlert() {
    let errorDescription = BackendError.notAuthorized.humanDescription
    let alertController = UIAlertController(title: errorDescription.title, message: errorDescription.text, preferredStyle: UIAlertControllerStyle.alert)
    
    let alertButton = UIAlertAction(title: "OK", style: .default) { (alertAction: UIAlertAction) -> Void in
        
        alertController.dismiss(animated: true, completion: nil)
    }
    alertController.addAction(alertButton)
    
    DispatchQueue.main.async {
        alertController.presentIfNoAlertsPresented()
    }
}
