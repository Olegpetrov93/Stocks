//
//  APIStocksManager.swift
//  Stocks
//
//  Created by Oleg on 1/31/21.
//

import Foundation


enum ForecastType: FinalURLPoint {
    case current(token: String, symbol: String)
    case allStocks(token: String)
    case getLogoUrl(token: String, symbol: String)
    
    var baseURL: String {
        return "https://cloud.iexapis.com"
    }
    
    var path: String {
        switch self {
        case .current(let token, let symbol):
            return "/stable/stock/\(symbol)/quote?&token=\(token)"
        case .allStocks(let token):
            return "/stable/stock/market/list/gainers?&token=\(token)"
        case .getLogoUrl(let token, let symbol):
            return "/stable/stock/\(symbol)/logo?&token=\(token)"
        }
    }
    
    var request: URLRequest {
        let url = URL(string: "\(baseURL)\(path)")
        return URLRequest(url: url!)
    }
}

final class APIStocksManager: APIManager {
    static let shared = APIStocksManager(token: "pk_76a4a3d58fe842ebbdaaae3a84f47bf1")

    let sessionConfiguration: URLSessionConfiguration
    lazy var session: URLSession = {
        return URLSession(configuration: self.sessionConfiguration)
    } ()
    
    let token: String
    
    init(sessionConfiguration: URLSessionConfiguration, token: String) {
        self.sessionConfiguration = sessionConfiguration
        self.token = token
    }
    
    convenience init(token: String) {
        self.init(sessionConfiguration: URLSessionConfiguration.default, token: token)
    }
    
    func fetchCurrentStocksWith(symbol: String, completionHandler: @escaping (APIResult<StocksModel>) -> Void) {
        let request = ForecastType.current(token: self.token, symbol: symbol).request
        
        fetch(request: request, parse: { (json) -> StocksModel? in
            if let stockModel = StocksModel(JSON: json) {
                return stockModel
            } else {
                return nil
            }
            
        }, completionHandler: completionHandler)
    }
    
    func fetchAllStocks(completionHandler: @escaping (APIResult<[StocksModel]>) -> Void) {
        let request = ForecastType.allStocks(token: self.token).request
        
        fetch(request: request, parse: { (json) -> [StocksModel]? in
            if let arr = json["arr"] as? [[String: AnyObject]] {
                let stockModels = arr.compactMap { dict -> StocksModel? in
                    return StocksModel(JSON: dict)
                }
                return stockModels
            } else {
                return nil
            }
            
        }, completionHandler: completionHandler)
    }
    
    func getLogoUrl(symbol: String, completionHandler: @escaping (APIResult<String>) -> Void) {
        let request = ForecastType.getLogoUrl(token: self.token, symbol: symbol).request
        
        fetch(request: request, parse: { (json) -> String? in
            if let urlString = json["url"] as? String {
                return urlString
            } else {
                return nil
            }
            
        }, completionHandler: completionHandler)
    }
    
    
}
