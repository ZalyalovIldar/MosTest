//
//  LoginController.swift
//  VK-MOS
//
//  Created by Ildar Zalyalov on 20.01.17.
//  Copyright © 2017 com.personal.ildar. All rights reserved.
//

import UIKit

class LoginController: UIViewController {

    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUpMainAppereances()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.animateLoginButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: Custom methods
    func setUpMainAppereances(){
        self.loginButton.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
    }
    
    func animateLoginButton(){
        self.loginButton.layoutIfNeeded()
        UIView.animate(withDuration: 0.7, animations: {[weak self] in
            self?.loginButton.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        })
    }
    
}
