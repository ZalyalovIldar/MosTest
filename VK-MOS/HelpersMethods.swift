//
//  Helpers.swift
//  VK-MOS
//
//  Created by Ildar Zalyalov on 26.01.17.
//  Copyright © 2017 com.personal.ildar. All rights reserved.
//

import Foundation

// This class Help not write code twice in Project

func downloadAvatarImage(url: URL?, imageView: UIImageView){
    guard let pUrl = url else {return}
    imageView.sd_setImage(with: pUrl)
    imageView.fs_cornerRadius = imageView.fs_width/2
}

func downloadMainImage(attachmentsArr: [Attachment], constraint:NSLayoutConstraint, imageView: UIImageView){
    guard attachmentsArr.count > 0 else {
        constraint.priority = 999; return}
    constraint.priority = UILayoutPriorityDefaultLow
    guard let pUrl = attachmentsArr[0].typeContent?.phtoUrl else {return}
    imageView.sd_setImage(with: pUrl)
    
}

