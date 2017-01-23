

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
    var userId: String?
    var userToken: String?
    
    var task: DataRequest? {
        willSet {
            self.task?.cancel()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.startLoadVKAuthPage()
    }
    
    deinit {
        self.webView.stopLoading()
        self.task?.cancel()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Custom methods
    func startLoadVKAuthPage(){
        self.webView.loadRequest(URLRequest(url: VKAuthURL))
    }
    
    func getMainUserInfoWith(userId:String, complitionBlock:@escaping (Bool)->()){
        SVProgressHUD.show()
        self.task = Router.User.getMainUserInfo(userId: userId).request().responseObject({[weak self] (response: DataResponse<RTUserResponse>) in
            
            switch response.result{
            case .success(let value):
                guard let user = value.user else {ShowErrorAlert(); return}
                do {
                    guard let realm = BDRealm else {return}
                    try realm.write({
                        realm.delete(realm.objects(MainUser.self))
                        realm.add(user, update: true)
                        let mainUser = realm.objects(MainUser.self).first
                        mainUser?.token = (self?.userToken)!
                    })
                  complitionBlock(true)
                } catch let error {
                    complitionBlock(false)
                    Logger.error("\nSaving User info Error: \(error)")
                }
                DispatchQueue.main.async(execute: {
                    SVProgressHUD.dismiss()
                })
            case .failure(let error):
                complitionBlock(false)
                Logger.error("Getting user info Error \(error)")
                DispatchQueue.main.async(execute: {
                    SVProgressHUD.dismiss()
                })
            }
        })
    }
    
    func separeteAndSaveTokenFrom(string: String){
        let accesToken = string.fs_getStringBetweenString("access_token=", secondString: "&")
        self.userToken = accesToken
        
        let endStr = string.substring(from: string.index(string.endIndex, offsetBy: -4))
        guard let LuserId = string.fs_getStringBetweenString("user_id=", secondString: endStr) else{return}
        self.userId = LuserId + endStr
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
        SVProgressHUD.dismiss()
        ShowErrorAlert()
    }
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        if request.url?.absoluteString.contains("access_token=") == true {
            guard let urlWithToken = request.url?.absoluteString else {return false}
            self.separeteAndSaveTokenFrom(string: urlWithToken)
            guard let LuserId = self.userId else {return false}
            self.getMainUserInfoWith(userId: LuserId, complitionBlock: {[weak self] (finished) in
                if finished == true{self?.switchToNewsScreen()}
            })
        }
        
        return true
    }
}
