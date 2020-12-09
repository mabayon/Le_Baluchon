//
//  Moya+Router.swift
//  Le Baluchon
//
//  Created by Mahieu Bayon on 09/12/2020.
//  Copyright © 2020 Mabayon. All rights reserved.
//

import Moya

let fixerProvider = MoyaProvider<MoyaRouter>()

public enum MoyaRouter {
    case fixer(symbols: String = "USD,GBP,JPY,CNY,CAD")
}

extension MoyaRouter: TargetType {
    public var baseURL: URL { return URL(string: Fixer.baseURL)! }

    public var path: String {
        return "/latest"
    }
        
    public var method: Method {
        return .get
    }
    
    public var sampleData: Data {
        switch self {
        case .fixer:
            guard let url = Bundle.main.url(forResource: "ExchangeRates", withExtension: "json"),
                  let data = try? Data(contentsOf: url) else {
                return Data()
            }
            return data
        }
    }
    
    public var task: Task {
        switch self {
        case .fixer(let symbols):
            return .requestParameters(parameters: ["access_key": APIKeys.Fixer.rawValue, "symbols": symbols], encoding: URLEncoding.queryString)
        }
    }
    
    public var headers: [String : String]? {
        return nil
    }
    
}
