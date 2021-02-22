//
//  CheksTableViewController.swift
//  Stocks
//
//  Created by Oleg on 1/31/21.
//

import UIKit

class CheksTableViewController: UITableViewController {
    
    var checkStock : StocksModel?
    
    @IBOutlet weak var companyNameLabel: UILabel!
    
    @IBOutlet weak var companySymbolLabel: UILabel!
    
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var changeLabel: UILabel!
    @IBOutlet weak var companyImage: AsyncImageView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        setupScreen()
    }
    private func setupScreen() {
        
        if checkStock != nil {
            self.companyNameLabel.text = checkStock?.companyName
            self.companySymbolLabel.text = checkStock?.symbol
            self.priceLabel.text = checkStock?.priceString
            self.changeLabel.text = checkStock?.changeString
            self.setImage(with: checkStock?.symbol ?? "")
        }
    }
    
    func setImage(with symbol: String) {
        APIStocksManager.shared.getLogoUrl(symbol: symbol) { (result) in
            switch result {
            case .Success(let url):
                self.companyImage.imageFromServerURL(url: url)
            case .Failure(let error as NSError):
                print(error)
            default: break
            }
        }
    }
}


