//
//  APIStocksManager.swift
//  Stocks
//
//  Created by Oleg on 1/31/21.
//

import Foundation


enum ForecastType: FinalURLPoint {
  case Current(token: String, symbol: String)
  
  var baseURL: String {
    return "https://cloud.iexapis.com"
  }
  
  var path: String {
    switch self {
    case .Current(let token, let symbol):
      return "/stable/stock/\(symbol)/quote?&token=\(token)"
    }
  }
  
  var request: URLRequest {
    let url = URL(string: "\(baseURL)\(path)")
    return URLRequest(url: url!)
  }
}



final class APIStocksManager: APIManager {
  
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
    let request = ForecastType.Current(token: self.token, symbol: symbol).request
    
    fetch(request: request, parse: { (json) -> StocksModel? in
      if let dictionary = json["currently"] as? [String: AnyObject] {
        return StocksModel(JSON: dictionary)
      } else {
        return nil
      }
      
      }, completionHandler: completionHandler)
  }
}
