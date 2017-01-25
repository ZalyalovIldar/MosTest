//
//  NewsCell.swift
//  VK-MOS
//
//  Created by Ildar Zalyalov on 22.01.17.
//  Copyright © 2017 com.personal.ildar. All rights reserved.
//

import UIKit

class NewsCell: UITableViewCell {
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var postNameLabel: UILabel!
    @IBOutlet weak var postDateLabel: UILabel!
    
    @IBOutlet weak var postTextLabel: UILabel!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var postLikesLabel: UILabel!
    @IBOutlet weak var postCommentsLabel: UILabel!
    @IBOutlet weak var postRepostsLabel: UILabel!
    
    @IBOutlet weak var lineTopConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    override func prepareForReuse() {
        self.avatarImageView.image = nil
        self.postDateLabel.text = nil
        self.postNameLabel.text = nil
        self.postTextLabel.text = nil
        self.postImageView.image = nil
        
        self.postLikesLabel.text = nil
        self.postRepostsLabel.text = nil
        self.postCommentsLabel.text = nil
    }
    
    
    func prepareCellWith(item:Item, group: Group){
        self.postNameLabel.text = group.name

        self.downloadAvatarImage(url: group.phtoUrl)
        self.downloadMainImage(attachmentsArr: Array(item.attachments))
        
        self.setPost(item: item)
    }
    
    func prepareCellWith(item:Item, profile: Profile){
        self.postNameLabel.text = profile.fullname
        
        self.downloadAvatarImage(url: profile.phtoUrl)
        self.downloadMainImage(attachmentsArr: Array(item.attachments))
        
        self.setPost(item: item)
    }
    
    func setPost(item: Item){
        self.postDateLabel.text = item.postedDate
        self.postTextLabel.text = item.text
    
        guard let likeCount = item.likes?.count, let comCount = item.comments?.count,
            let repCount = item.reposts?.count else {return}
        self.postLikesLabel.text    = String(describing: likeCount)
        self.postCommentsLabel.text = String(describing: comCount)
        self.postRepostsLabel.text  = String(describing: repCount)
    }
    
    func downloadAvatarImage(url: URL?){
        guard let pUrl = url else {return}
        self.avatarImageView.sd_setImage(with: pUrl)
        self.avatarImageView.fs_cornerRadius = self.avatarImageView.fs_width/2
    }
    
    func downloadMainImage(attachmentsArr: [Attachment]){
        guard attachmentsArr.count > 0 else {
            self.lineTopConstraint.priority = 999; return}
        self.lineTopConstraint.priority = UILayoutPriorityDefaultLow
        guard let pUrl = attachmentsArr[0].typeContent?.phtoUrl else {return}
        self.postImageView.sd_setImage(with: pUrl)
        
    }
    
    
}
