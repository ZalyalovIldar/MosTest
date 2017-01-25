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
    dynamic var token: String = ""
    
    var fullname: String {
        return firstName + " " + lastName
    }
    
    class func currentUser() -> MainUser?{
        guard let realmUser = BDRealm?.objects(MainUser.self).first else {return nil}
        return realmUser
        
    }
    
    class func removeUser(){
        guard let realm = BDRealm else{return}
        try! realm.write({
            realm.delete(realm.objects(MainUser.self))
        })
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    override static func ignoredProperties() -> [String] {
        return ["fullname"]
    }
    
    required convenience init?(map: ObjectMapper.Map) {
        guard let _ = map.JSON["id"] as? Int else {return nil}
        self.init()
    }
}

extension MainUser: Mappable{
    
    func mapping(map: ObjectMapper.Map) {
        self.id         <- map["id"]
        self.firstName  <- map["first_name"]
        self.lastName   <- map["last_name"]
    }
}
