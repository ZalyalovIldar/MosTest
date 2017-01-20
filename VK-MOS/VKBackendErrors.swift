//
//  VKBackendErrors.swift
//  VK-MOS
//
//  Created by Ildar Zalyalov on 20.01.17.
//  Copyright © 2017 com.personal.ildar. All rights reserved.
//

import Foundation
import ObjectMapper

class BackendErrorsContainer {
    var error: Int?
    var isTokenExpired: Bool = false
    
    required convenience init?(map: ObjectMapper.Map) {
        self.init()
    }
}

extension BackendErrorsContainer: Mappable {
    func mapping(map: ObjectMapper.Map) {
        self.error <- map["status"]
        
        guard let error = map.JSON["error"] as? String else {return}
        self.isTokenExpired = error.contains("")
    }
}
