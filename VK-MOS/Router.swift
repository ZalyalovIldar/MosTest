//
//  Router.swift
//  VK-MOS
//
//  Created by Ildar Zalyalov on 20.01.17.
//  Copyright © 2017 com.personal.ildar. All rights reserved.
//

import Foundation

//Use Router to send request 

enum Router{
    static let BaseURL = "https://api.vk.com/method"
    
    //MARK: -
    static let manager: SessionManager = {
        let configuration = URLSessionConfiguration.default
        
        var headers: [AnyHashable: Any] = [:]
        for header in SessionManager.defaultHTTPHeaders {
            headers.updateValue(header.1, forKey: header.0)
        }
        configuration.httpAdditionalHeaders = headers
        
        let manager = SessionManager(configuration: configuration)
        return manager
    }()
    
    static let networkReachabilityManager: NetworkReachabilityManager? = {
        let networkReachabilityManager = NetworkReachabilityManager()
        networkReachabilityManager?.startListening()
        return networkReachabilityManager
    }()
    
    static var extendHeaders: [String : String] {
        var headers: [String : String] = [:]
        
        headers.updateValue("no-cache", forKey: "Cache-Control")
        
        
        return headers
    }
    
}

protocol RouterProtocol {
    var settings: RTRequestSettings {get}
    var path: String {get}
    var parameters: [String : AnyObject]? {get}
    
    var multipartParameters: [String: Data]? {get}
}

extension RouterProtocol {
    var multipartParameters: [String: Data]? {
        get {
            return nil
        }
    }
}

extension RouterProtocol {
    
    func request (baseUrl: String = Router.BaseURL) -> DataRequest {
        let path = "\(baseUrl)\(self.path)"
        
        let headers = Router.extendHeaders
        
        let request = Router.manager.request(path, method: self.settings.method, parameters: self.parameters, encoding: self.settings.encoding, headers: headers).validate()
        
        return request
    }
    
}

struct RTRequestSettings {
    let method: HTTPMethod
    let encoding: ParameterEncoding
    
    init (method: HTTPMethod, encoding: ParameterEncoding? = nil) {
        self.method = method
        self.encoding = encoding ?? method.encoding
    }
}

extension HTTPMethod {
    var encoding: ParameterEncoding {
        switch self {
        case .get                   : return URLEncoding.default
        case .post, .put, .patch    : return URLEncoding.default
        default                     : return URLEncoding.default
        }
    }
}
