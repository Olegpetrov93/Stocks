//
//  TableViewCell.swift
//  Stocks
//
//  Created by Oleg on 1/31/21.
//

import UIKit

class StockTableViewCell: UITableViewCell {
    
    @IBOutlet weak var companyNameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var changeLabel: UILabel!
    @IBOutlet weak var companyImage: AsyncImageView!
    
    func configure(with stockModel: StocksModel) {
        self.companyNameLabel.text = stockModel.companyName
        self.priceLabel.text = stockModel.priceString
        self.changeLabel.text = stockModel.changeString
        self.setImage(with: stockModel.symbol)
        self.companyImage.layer.cornerRadius = 75 / 2
        switch stockModel.change {
        case ..<0:
            priceLabel.textColor = .red
        case 1...:
            priceLabel.textColor = .green
        case 0:
            priceLabel.textColor = .black
        default:
            break
        }
    }
    
    func setImage(with symbol: String) {
        APIStocksManager.shared.getLogoUrl(symbol: symbol) { [weak self] (result) in
            switch result {
            case .Success(let url):
                self?.companyImage.imageFromServerURL(url: url)
            case .Failure(let error as NSError):
                print(error)
            default: break
            }
        }
    }
}
