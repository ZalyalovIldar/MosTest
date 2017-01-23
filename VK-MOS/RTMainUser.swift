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
    }
}

extension Router.User: RouterProtocol {
    
    var settings: RTRequestSettings {
        switch self {
        case .getMainUserInfo(_)            :return RTRequestSettings(method: .get)
        }
    }
    
    var path: String {
        switch self {
        case .getMainUserInfo(_)   : return "/users.get"
        }
    }
    
    var parameters: [String : AnyObject]? {
        switch self {
        case .getMainUserInfo(let userId): return ["user_id": userId as AnyObject, "v":"5.52" as AnyObject]
        default:
            return nil
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
class RTUserResponse: Mappable {
    var user: MainUser?
    var responseArr: Array<Any>?
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        self.user <- map["response.0"]
    }
}
