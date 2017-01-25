//
//  VKErrors.swift
//  VK-MOS
//
//  Created by Ildar Zalyalov on 20.01.17.
//  Copyright © 2017 com.personal.ildar. All rights reserved.
//

import Foundation

protocol MYError: Swift.Error {
    var description: String {get}
}

extension MYError {
    func log () {
        Logger.error("\(self._domain)(\(self._code)): \(self.description)")
    }
}

struct ErrorHumanDescription {
    let title: String
    let text: String
    
    init (title: String? = nil, text: String) {
        self.title = title ?? "Error"
        self.text = text
    }
}

protocol HumanErrorType: MYError {
    var humanDescription: ErrorHumanDescription {get}
}

enum VKError: Swift.Error {
    case request(RequestError)
    case backend(BackendError)
    case serialize(SerializationError)
    case unknown(Swift.Error?)
}

extension VKError {
    init (request: RequestError) {
        self = .request(request)
    }
    
    init (backend: BackendError) {
        self = .backend(backend)
    }
    
    init (serialize: SerializationError) {
        self = .serialize(serialize)
    }
    
    init (error: Swift.Error?) {
        self = .unknown(error)
    }
}

enum SerializationError {
    case wrongType
    case requeriedFieldMissing
    case jsonSerializingFailed
    case unknown
    
    var error: VKError {return VKError(serialize: self)}
}

enum BackendError {
    case notAuthorized
    case internetIsOffline
    var error: VKError {return VKError(backend: self)}
}

enum RequestError {
    case canceled
    case unknown(error: Swift.Error?)
    
    var error: VKError {return VKError(request: self)}
}
