//
//  Router.swift
//  Le Baluchon
//
//  Created by Mahieu Bayon on 08/12/2020.
//  Copyright © 2020 Mabayon. All rights reserved.
//

import Foundation
import Alamofire

enum Router: URLRequestConvertible {
    case getExchangeRates
    
    var url: URL {
        return URL(string: Fixer.baseURL)!
    }
    
    var urlComponents: URLComponents {
        guard var urlComponents = URLComponents(string: url.absoluteString) else { return URLComponents() }
        urlComponents.queryItems = [
            URLQueryItem(name: "access_key", value: APIKeys.Fixer.rawValue),
            URLQueryItem(name: "symbols", value: "USD,GBP,JPY,CNY,CAD")
        ]
        return urlComponents
    }
    
    var method: HTTPMethod {
        switch self {
        case .getExchangeRates: return .get
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        var request = URLRequest(url: try urlComponents.asURL())
        request.method = method
                
        return request
    }
}
