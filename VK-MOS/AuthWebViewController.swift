//
//  AuthWebViewController.swift
//  VK-MOS
//
//  Created by Ildar Zalyalov on 21.01.17.
//  Copyright © 2017 com.personal.ildar. All rights reserved.
//

import UIKit

class AuthWebViewController: UIViewController {

    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.startLoadVKAuthPage()
    }
    
    deinit {
        self.webView.stopLoading()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Custom methods
    func startLoadVKAuthPage(){
        self.webView.loadRequest(URLRequest(url: VKAuthURL))
    }
    
    func separeteAndSaveTokenFrom(string: String){
        let accesToken = string.fs_getStringBetweenString("access_token=", secondString: "&")
        UserDefaults.standard.set(accesToken, forKey: VKUserDefaultsKey.UserAccesToken)
        UserDefaults.standard.synchronize()
        self.switchToNewsScreen()
    }
    
    func switchToNewsScreen(){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate,
            let window = appDelegate.window else {return}
        window.rootViewController = Storyboard.newsWall.firstController
    }
}

extension AuthWebViewController: UIWebViewDelegate{
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        SVProgressHUD.show()
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        SVProgressHUD.dismiss()
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        ShowErrorAlert()
    }
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        if request.url?.absoluteString.contains("access_token=") == true {
            guard let urlWithToken = request.url?.absoluteString else {return false}
            self.separeteAndSaveTokenFrom(string: urlWithToken)
        }
        
        return true
    }
}
