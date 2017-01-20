//
//  VKErrorsDescription.swift
//  VK-MOS
//
//  Created by Ildar Zalyalov on 20.01.17.
//  Copyright © 2017 com.personal.ildar. All rights reserved.
//

import Foundation

extension SerializationError: MYError {
    var description: String {
        switch self {
        case .wrongType             : return "DataResponse has wrong type"
        case .requeriedFieldMissing : return "One of required fields is missing"
        case .jsonSerializingFailed : return "Serialization to JSON object was failed"
        case .unknown               : return "Unknown serialization error"
        }
    }
}

extension BackendError: HumanErrorType {
    var description: String {
        switch self {
        case .notAuthorized     : return "User is not authorized"
        }
    }
    
    var humanDescription: ErrorHumanDescription {
        switch self {
        case .notAuthorized     : return ErrorHumanDescription(title: "Error", text: "")
        }
    }
}
