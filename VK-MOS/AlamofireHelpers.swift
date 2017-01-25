//
//  AlamofireHelpers.swift
//  VK-MOS
//
//  Created by Ildar Zalyalov on 20.01.17.
//  Copyright © 2017 com.personal.ildar. All rights reserved.
//

import Foundation

extension DataRequest{
    func responseObject<T: Mappable>(_ completionHandler: @escaping (DataResponse<T>) -> Void) -> Self {
        
        let responseSerializer = DataResponseSerializer<T> { request, response, data, error in
            guard error == nil else {
                return DataRequest.handleErrors(response, error: error!, data: data)
            }
            
            let result = Request.serializeResponseJSON(options: .allowFragments, response: response, data: data, error: error)
            
            switch result {
            case .success(let value):
                
                guard let json = value as? [String : AnyObject] else {
                    return .failure(VKError(serialize: .wrongType))
                }
                
                guard var object = T(JSON: json) else {return .failure(VKError(serialize: .requeriedFieldMissing))}
                
                object = Mapper<T>().map(JSONObject: json, toObject: object)
                
                return .success(object)
                
            case .failure(_):
                if let object = T(JSON: [:]) , data?.count == 0 {
                    return .success(object)
                }
                return .failure(VKError(serialize: .jsonSerializingFailed))
            }
        }
        
        return response(responseSerializer: responseSerializer, completionHandler: completionHandler)
    }
    
    class func handleErrors<T: Mappable>(_ response: HTTPURLResponse?, error: Swift.Error, data: Data?) -> Result<T> {
        do {
            if let nsError = error as? NSError, nsError.code == -999 {
                return .failure(VKError(request: RequestError.canceled))
            }
            
            if let nsError = error as? NSError, nsError.code == -1009 {
                ShowErrorAlert(BackendError.internetIsOffline.humanDescription.title, message: BackendError.internetIsOffline.humanDescription.text)
                return .failure(VKError(backend: BackendError.internetIsOffline))
            }
            
            guard let lData = data, let json = try JSONSerialization.jsonObject(with: lData as Data, options: []) as? [String : AnyObject] else {
                return .failure(VKError(serialize: .wrongType))
            }
            Logger.error(json)
            if response?.statusCode == 401 && response?.url?.host == NSURL(string: Router.BaseURL)?.host {
                var object = BackendErrorsContainer()
                object = Mapper<BackendErrorsContainer>().map(JSONObject: json["error"], toObject: object)
                if object.isTokenExpired {
                    ShowUnauthorizedAlert()
                    return .failure(VKError(backend: .notAuthorized))
                }
            }
            
        }
        catch let error {
            Logger.error("\(error)")
        }
        return .failure(VKError(request: .unknown(error: error)))
    }
}
