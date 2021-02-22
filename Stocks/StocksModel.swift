//
//  StocksModel.swift
//  Stocks
//
//  Created by Oleg on 1/31/21.
//

import Foundation
import UIKit

struct StocksModel: Codable {
    
    let companyName: String
    let symbol: String
    let latestPrace : Double
    let change: Double
}

extension StocksModel: JSONDecodable {
    
    init?(from data: Data?) {
        guard let data = data else {
            return nil
        }
        do {
            self = try JSONDecoder().decode(StocksModel.self, from: data)
        } catch {
            return nil
        }
    }
    
    init?(JSON: [String : AnyObject]) {
        guard let companyName = JSON["companyName"] as? String,
              let symbol = JSON["symbol"] as? String,
              let latestPrace = JSON["latestPrice"] as? Double,
              let change = JSON["change"] as? Double else {
            return nil
        }
        
        self.companyName = companyName
        self.symbol = symbol
        self.latestPrace = latestPrace
        self.change = change
    }
}

extension StocksModel {
    
    var priceString: String {
        return "\(latestPrace)$"
    }
    
    var changeString: String {
        return "\(change)%"
    }
}
