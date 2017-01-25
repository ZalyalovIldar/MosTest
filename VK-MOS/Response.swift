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
    private dynamic var dictionaryData: NSData?
    var dictionary: [String: String] {
        get {
            guard let dictionaryData = dictionaryData else {
                return [String: String]()
            }
            do {
                let dict = try JSONSerialization.jsonObject(with: dictionaryData as Data, options: []) as? [String: String]
                return dict!
            } catch {
                return [String: String]()
            }
        }
        
        set {
            do {
                let data = try JSONSerialization.data(withJSONObject: newValue, options: [])
                dictionaryData = data as NSData?
            } catch {
                dictionaryData = nil
            }
        }
    }
    
    override static func ignoredProperties() -> [String] {
        return ["dictionary"]
    }
    
    required convenience init?(map: ObjectMapper.Map) {
        self.init()
    }
}

extension Response: Mappable{
    func mapping(map: ObjectMapper.Map) {
         self.dictionary <- map
    }
}
