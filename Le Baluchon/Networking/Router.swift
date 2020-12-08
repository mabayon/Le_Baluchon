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
        return URL(string: Fixer.url)!
    }
    
    var method: HTTPMethod {
        switch self {
        case .getExchangeRates: return .get
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        var request = URLRequest(url: url)
        request.method = method
                
        return request
    }
}
