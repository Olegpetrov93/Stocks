//
//  ViewController.swift
//  Stocks
//
//  Created by Oleg on 1/31/21.
//

import UIKit

class ViewController: UIViewController {
    
    //UI
    @IBOutlet weak var companyNameLabel: UILabel!
    @IBOutlet weak var symbolLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var changeLabel: UILabel!
    @IBOutlet weak var pickerViewCompany: UIPickerView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    // Private
    private lazy var companies = [
        "Apple": "aapl",
        "Microsoft": "msft",
        "Google": "goog",
        "Amazon": "amzn",
        "Facebook": "fb"]
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.pickerViewCompany.dataSource = self
        self.pickerViewCompany.delegate = self
        
        self.companyNameLabel.text = "Tinkoff"
        
        self.activityIndicator.hidesWhenStopped = true
        
        self.requestQouteUpdate()
        
    }
    private func requestQouteUpdate() {
        self.companyNameLabel.text = "-"
        self.symbolLabel.text = "-"
        self.priceLabel.text = "-"
        self.changeLabel.text = "-"
        self.priceLabel.textColor = .black
        self.activityIndicator.startAnimating()
        
        let selectedRow = pickerViewCompany.selectedRow(inComponent: 0)
        let selectedSymbol = Array(companies.values)[selectedRow]
        self.requestQuote(for: selectedSymbol)
    }
    func updateUIWith(stocksModel: StocksModel) {
        
        self.companyNameLabel.text = stocksModel.companyName
        self.symbolLabel.text = stocksModel.symbol
        self.priceLabel.text = stocksModel.priceString
        self.changeLabel.text = stocksModel.changeString
    }
    //MARK: -Private
    
    
    private func requestQuote(for symbol: String) {
        let token = "pk_76a4a3d58fe842ebbdaaae3a84f47bf1"
        guard let url = URL(string: "https://cloud.iexapis.com/stable/stock/\(symbol)/quote?token=\(token)") else {
            return
        }
        let dataTask = URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            if let data = data,
               (response as? HTTPURLResponse)?.statusCode == 200,
               error == nil {
                self?.parseQuote(from: data)
            } else {
                print("Network error!")
            }
        }
        dataTask.resume()
    }
    
    
    
    private func parseQuote(from data: Data) {
        do {
            let jsonObject = try JSONSerialization.jsonObject(with: data)
            
            guard
                let json = jsonObject as? [String: Any],
                let companyName = json["companyName"] as? String,
                let symbol = json["symbol"] as? String,
                let latestPrace = json["latestPrice"] as? Double,
                let change = json["change"] as? Double
            else { return print("Invalid JSON") }
            
            DispatchQueue.main.async { [weak self] in
                self?.displayStockInfo(companyName: companyName, companySymbol: symbol, price: latestPrace, priceChange: change)
            }
        } catch {
            print("JSON parsing error" + error.localizedDescription)
        }
    }
    private func displayStockInfo(companyName: String, companySymbol: String, price: Double, priceChange: Double) {
        self.activityIndicator.stopAnimating()
        self.companyNameLabel.text = companyName
        self.symbolLabel.text = companySymbol
        self.priceLabel.text = "\(price)$"
        self.changeLabel.text = "\(priceChange)%"
        switch priceChange {
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
}
//MARK: - UIPickerViewDataSourse

extension ViewController: UIPickerViewDataSource {
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return companies.keys.count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
}
//MARK: - UIPickerViewDelegate

extension ViewController: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return Array(companies.keys)[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent: Int) {
        //        requestQouteUpdate()
        let selectedSymbol = Array(companies.values)[row]
        
        
        APIStocksManager.shared.fetchCurrentStocksWith(symbol: selectedSymbol) { [weak self] (result) in
            switch result {
            case .Success(let stocksModel):
                self?.updateUIWith(stocksModel: stocksModel)
            case .Failure(let error as NSError):
                
                let alertController = UIAlertController(title: "Unable to get data ", message: "\(error.localizedDescription)", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertController.addAction(okAction)
                
                self?.present(alertController, animated: true, completion: nil)
            default: break
            }
        }
    }
}

