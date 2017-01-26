//
//  RTMainUser.swift
//  VK-MOS
//
//  Created by Ildar Zalyalov on 23.01.17.
//  Copyright © 2017 com.personal.ildar. All rights reserved.
//

import Foundation
import ObjectMapper

extension Router{
    enum User{
        case getMainUserInfo(userId: String)
        case getMainUserNews(userToken: String, start_from: String)
        case addLikeToItem(withId: Int, type:String, userToken: String, ownerId: Int)
        case deleteLikeFromItem(withId: Int, type:String, userToken: String, ownerId: Int)
    }
}

extension Router.User: RouterProtocol {
    
    var settings: RTRequestSettings {
        switch self {
        case .getMainUserInfo(_)            :return RTRequestSettings(method: .get)
        case .getMainUserNews(_)            :return RTRequestSettings(method: .get)
        case .addLikeToItem(_)              :return RTRequestSettings(method: .post)
        case .deleteLikeFromItem(_)         :return RTRequestSettings(method: .post)
        }
    }
    
    var path: String {
        switch self {
        case .getMainUserInfo(_)         : return "/users.get"
        case .getMainUserNews(_)         : return "/newsfeed.get"
        case .addLikeToItem(_)           : return "/likes.add"
        case .deleteLikeFromItem(_)      : return "/likes.delete"
        }
    }
    
    var parameters: [String : AnyObject]? {
        switch self {
        case .getMainUserInfo(let userId)                   : return ["user_id": userId as AnyObject, "v":"5.62" as AnyObject]
        case .getMainUserNews(let token, let startFrom)     : return ["filters":"post,photo,note" as AnyObject, "return_banned":"1" as AnyObject, "start_from":startFrom as AnyObject, "count":20 as AnyObject,"access_token":token as AnyObject, "v":"5.62" as AnyObject]
        case .addLikeToItem(let itemId, let type, let token, let ownerId): return ["item_id":itemId as AnyObject, "type": type as AnyObject, "access_token":token as AnyObject, "owner_id":ownerId as AnyObject, "v":"5.62" as AnyObject]
        case .deleteLikeFromItem(let itemId, let type, let token, let ownerId) : return
            ["item_id":itemId as AnyObject, "type": type as AnyObject, "access_token":token as AnyObject, "owner_id":ownerId as AnyObject, "v":"5.62" as AnyObject]
        }
    }
    
}

class RTEmptyResponse: Mappable{
    var response: Response?
    required convenience init?(map: Map) {
        self.init()
    }
    func mapping(map: Map) {
        self.response <- map["response"]
    }
}
class RTUserNewsFeedResponse: Mappable{
    var newsFeed: NewsFeed?
    var isMapped = false
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        if isMapped == false{
          self.newsFeed <- map["response"]
            isMapped = true
        }
    }
}
class RTUserResponse: Mappable {
    var user: MainUser?
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        self.user <- map["response.0"]
    }
}
