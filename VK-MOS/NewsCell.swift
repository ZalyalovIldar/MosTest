//
//  NewsCell.swift
//  VK-MOS
//
//  Created by Ildar Zalyalov on 22.01.17.
//  Copyright © 2017 com.personal.ildar. All rights reserved.
//

import UIKit

protocol VKItemTableViewCellDelegate {
    func didTapLikeFor(item:Item, withButton: UIButton, andLabel: UILabel)
}

class NewsCell: UITableViewCell {
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var postNameLabel: UILabel!
    @IBOutlet weak var postDateLabel: UILabel!
    
    @IBOutlet weak var postTextLabel: UILabel!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var postLikesLabel: UILabel!
    @IBOutlet weak var postCommentsLabel: UILabel!
    @IBOutlet weak var postRepostsLabel: UILabel!
    
    @IBOutlet weak var postLikeButton: UIButton!
    @IBOutlet weak var lineTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var postImageHeightConstraint: NSLayoutConstraint!
    
    var currentItem: Item?
    var delegate: VKItemTableViewCellDelegate?
    
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
    
    //MARK: Cell Preparing methods
    func prepareCellWith(item:Item, group: Group){
        self.postNameLabel.text = group.name
        
        downloadAvatarImage(url: group.phtoUrl, imageView: self.avatarImageView)
        downloadMainImage(attachmentsArr: Array(item.attachments), constraint:self.lineTopConstraint, imageView: self.postImageView)
        
        self.setTextPostData(item: item)
    }
    
    func prepareCellWith(item:Item, profile: Profile){
        self.postNameLabel.text = profile.fullname
        
        downloadAvatarImage(url: profile.phtoUrl, imageView: self.avatarImageView)
        downloadMainImage(attachmentsArr: Array(item.attachments), constraint:self.lineTopConstraint, imageView: self.postImageView)
        
        self.setTextPostData(item: item)
    }
    
    //MARK: Helper methods
    func setTextPostData(item: Item){
        self.currentItem = item
        self.postDateLabel.text = item.postedDate
        self.postTextLabel.text = item.text
        self.postLikeButton.isSelected = item.likes != nil ? (item.likes?.userLikes)! : false
        guard let likeCount = item.likes?.count, let comCount = item.comments?.count,
            let repCount = item.reposts?.count else {return}
        self.postLikesLabel.text    = String(describing: likeCount)
        self.postCommentsLabel.text = String(describing: comCount)
        self.postRepostsLabel.text  = String(describing: repCount)
    }
    
   
    
    //MARK: Buttons action
    
    @IBAction func likeButtonPressed(_ sender: UIButton) {
        guard let lItem = self.currentItem else {return}
        self.delegate?.didTapLikeFor(item: lItem, withButton: sender, andLabel: self.postLikesLabel)
    }
    
}
