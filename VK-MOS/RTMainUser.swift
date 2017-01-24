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
    }
}

extension Router.User: RouterProtocol {
    
    var settings: RTRequestSettings {
        switch self {
        case .getMainUserInfo(_)            :return RTRequestSettings(method: .get)
        case .getMainUserNews(_)            :return RTRequestSettings(method: .get)
        }
    }
    
    var path: String {
        switch self {
        case .getMainUserInfo(_)         : return "/users.get"
        case .getMainUserNews(_) : return "/newsfeed.get"
        }
    }
    
    var parameters: [String : AnyObject]? {
        switch self {
        case .getMainUserInfo(let userId): return ["user_id": userId as AnyObject, "v":"5.62" as AnyObject]
        case .getMainUserNews(let token, let startFrom)         : return ["filters":"post,photo,wall_photo,note" as AnyObject, "return_banned":"1" as AnyObject, "start_from":startFrom as AnyObject, "count":10 as AnyObject,"access_token":token as AnyObject, "v":"5.62" as AnyObject]
        }
    }
    
}

class RTEmptyResponse: Mappable{
    required convenience init?(map: Map) {
        self.init()
    }
    func mapping(map: Map) {
        
    }
}
class RTUserNewsFeedResponse: Mappable{
    var newsFeed: NewsFeed?
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        self.newsFeed <- map["response"]
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
