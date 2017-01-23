//
//  MainUser.swift
//  VK-MOS
//
//  Created by Ildar Zalyalov on 23.01.17.
//  Copyright © 2017 com.personal.ildar. All rights reserved.
//

import Foundation
import ObjectMapper

class MainUser: Object {
    dynamic var id: Int = 0
    dynamic var firstName: String = ""
    dynamic var lastName: String = ""
    
    var token: String?{
        get{
            return UserDefaults.standard.object(forKey: VKUserDefaultsKey.UserAccesToken) as! String?
        }
        set(newToken){
            UserDefaults.standard.set(newToken, forKey: VKUserDefaultsKey.UserAccesToken)
        }
    }
    
    var fullname: String {
        return firstName + " " + lastName
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    override static func ignoredProperties() -> [String] {
        return ["token", "fullname"]
    }
    
    required convenience init?(map: ObjectMapper.Map) {
        guard let _ = map.JSON["id"] as? Int else {return nil}
        self.init()
    }
}

extension MainUser: Mappable{
    
    func mapping(map: Map) {
        self.id <- map["id"]
        self.firstName <- map["first_name"]
        self.lastName <- map["last_name"]
    }
}
