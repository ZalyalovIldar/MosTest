//
//  NewsDetailController.swift
//  VK-MOS
//
//  Created by Ildar Zalyalov on 26.01.17.
//  Copyright © 2017 com.personal.ildar. All rights reserved.
//

import UIKit

class NewsDetailController: UIViewController {
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var postLikeButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var postDateLabel: UILabel!
    @IBOutlet weak var postTextLabel: UILabel!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var postLikesCountLabel: UILabel!
    @IBOutlet weak var postCommentCountLabel: UILabel!
    @IBOutlet weak var postRepostsCountLabel: UILabel!
    @IBOutlet weak var lineTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var postImageHeightConstraint: NSLayoutConstraint!
    
    var postItem: Item!
    var postName: String?
    var postAvatarUrl: URL?
    
    var task: DataRequest? {
        willSet {
            self.task?.cancel()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setPostTextData()
        downloadAvatarImage(url: postAvatarUrl, imageView: self.avatarImageView)
        downloadMainImage(attachmentsArr: Array(postItem.attachments), constraint: self.lineTopConstraint, imageView: self.postImageView)
        
        //using for IPad version
        if self.view.bounds.width > 414{
            self.postImageHeightConstraint.constant = self.postImageHeightConstraint.constant * 3
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Buttons action
    @IBAction func likeButtonPressed(_ sender: UIButton) {
        guard let user = MainUser.currentUser() else {return}
        if sender.isSelected == false{
            self.addLikeActionFrom(item: postItem, withButton: sender, andLabel: self.postLikesCountLabel, andToken: user.token)
        }else{
            self.deleteLikeActionFrom(item: postItem, withButton: sender, andLabel: self.postLikesCountLabel, andToken: user.token)
        }
    }
    
    //MARK: Helpers methods
    func setPostTextData(){
        self.nameLabel.text = postName
        self.postDateLabel.text = postItem.postedDate
        self.postTextLabel.text = postItem.text
        self.postLikeButton.isSelected = postItem.likes != nil ? (postItem.likes?.userLikes)! : false
        guard let likeCount = postItem.likes?.count, let comCount = postItem.comments?.count,
            let repCount = postItem.reposts?.count else {return}
        self.postLikesCountLabel.text    = String(describing: likeCount)
        self.postCommentCountLabel.text = String(describing: comCount)
        self.postRepostsCountLabel.text  = String(describing: repCount)
    }
    
    
    func addLikeActionFrom(item: Item, withButton: UIButton, andLabel: UILabel, andToken: String){
        self.task = Router.User.addLikeToItem(withId: item.postId, type: item.type, userToken: andToken, ownerId:item.sourceId).request().responseObject({(response:DataResponse<RTEmptyResponse>) in
            
            switch response.result{
            case .success(let value):
                guard let LResponseCount = value.response?.responseCount  else {return}
                
                Logger.debug("\nPost liked successfully: \(LResponseCount)")
                guard let realm = BDRealm else {return}
                do{
                    try! realm.write {
                        item.likes?.count = LResponseCount
                        item.likes?.userLikes = true
                    }
                }
                DispatchQueue.main.async(execute: {
                    withButton.isSelected = true
                    andLabel.text = "\(LResponseCount)"
                })
            case .failure(let error):
                Logger.error("\nError when adding like: \(error)")
            }
        })
    }
    
    func deleteLikeActionFrom(item: Item, withButton: UIButton, andLabel: UILabel, andToken: String){
        self.task = Router.User.deleteLikeFromItem(withId: item.postId, type: item.type, userToken: andToken, ownerId:item.sourceId).request().responseObject({(response:DataResponse<RTEmptyResponse>) in
            
            switch response.result{
            case .success(let value):
                guard let LResponseCount = value.response?.responseCount  else {return}
                
                Logger.debug("\nPost like removed successfully: \(LResponseCount)")
                guard let realm = BDRealm else {return}
                do{
                    try! realm.write {
                        item.likes?.count = LResponseCount
                        item.likes?.userLikes = false
                    }
                }
                DispatchQueue.main.async(execute: {
                    withButton.isSelected = false
                    andLabel.text = "\(LResponseCount)"
                })
            case .failure(let error):
                Logger.error("\nError when removing post like: \(error)")
            }
        })
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    

}
