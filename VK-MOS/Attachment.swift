//
//  Attachment.swift
//  VK-MOS
//
//  Created by Ildar Zalyalov on 22.01.17.
//  Copyright © 2017 com.personal.ildar. All rights reserved.
//

import Foundation
import ObjectMapper

class Attachment: Object {
    dynamic var type: String = ""
    dynamic var typeContent: Photo?
    
    required convenience init?(map: ObjectMapper.Map) {
        guard let _ = map.JSON["photo"] else {return nil}
        self.init()
    }
}

extension Attachment: Mappable{
    func mapping(map: ObjectMapper.Map) {
        self.type        <- map["type"]
        self.typeContent <- map["photo"]
    }
}
