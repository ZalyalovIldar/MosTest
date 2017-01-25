//
//  RealmSwift+ObjectMapperOperator.swift
//  VK-MOS
//
//  Created by Ildar Zalyalov on 24.01.17.
//  Copyright © 2017 com.personal.ildar. All rights reserved.
//

import Foundation
import RealmSwift
import ObjectMapper

infix operator <-
/// Maps object of Realm's List type
func <- <T: Mappable>(left: List<T>, right: Map)
{
    var array: [T]?
    
    if right.mappingType == .toJSON
    {
        array = Array(left)
    }
    
    array <- right
    
    if right.mappingType == .fromJSON
    {
        if let theArray = array
        {
    
            left.append(objectsIn: theArray)
        }
    }
}
