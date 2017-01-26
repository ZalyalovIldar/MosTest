//
//  Response.swift
//  VK-MOS
//
//  Created by Ildar Zalyalov on 26.01.17.
//  Copyright © 2017 com.personal.ildar. All rights reserved.
//
import Foundation
import ObjectMapper

class Response: Object {
    dynamic var responseCount: Int = 0
    
    required convenience init?(map: ObjectMapper.Map) {
        self.init()
    }
}

extension Response: Mappable{
    func mapping(map: ObjectMapper.Map) {
        guard let key = map.JSON.keys.first else{Logger.debug("Key not Exist"); return}
         self.responseCount <- map[key]
    }
}
