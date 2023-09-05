//
//  URLEncodedFormProtobufParameterEncoder.swift
//  GY_app_ios
//
//  Created by zhaoenjia on 2023/8/22.
//

import UIKit
import Alamofire

class URLEncodedFormProtobufParameterEncoder: ParameterEncoder {
    
    
    func encode<Parameters>(_ parameters: Parameters?, into request: URLRequest) throws -> URLRequest where Parameters : Encodable {
        
        guard let parameters = parameters else { return request }

        var request = request

        guard let _ = request.url else {
            throw AFError.parameterEncoderFailed(reason: .missingRequiredComponent(.url))
        }

        guard let _ = request.method else {
            let rawValue = request.method?.rawValue ?? "nil"
            throw AFError.parameterEncoderFailed(reason: .missingRequiredComponent(.httpMethod(rawValue: rawValue)))
        }

        if let data = parameters as? Data {
            request.httpBody = data
        }else{
            let rawValue = request.method?.rawValue ?? "nil"
            throw AFError.parameterEncoderFailed(reason: .missingRequiredComponent(.httpMethod(rawValue: rawValue)))
        }

        return request
    }
}
