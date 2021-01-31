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
    
    lazy var stocksManager = APIStocksManager(token: "pk_76a4a3d58fe842ebbdaaae3a84f47bf1")
    
    // Private
    private lazy var companies = [
        "Apple": "appl",
        "Microsoft": "msft",
        "Google": "goog",
        "Amazon": "amzn",
        "Facebook": "fb"]
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pickerViewCompany.dataSource = self
        pickerViewCompany.delegate = self
        
        companyNameLabel.text = "Tinkoff"
        
        activityIndicator.startAnimating()
        activityIndicator.hidesWhenStopped = true
//        requestQuote(for: "AAPL")
        
    }
    func updateUIWith(stocksModel: StocksModel) {
      
        self.companyNameLabel.text = stocksModel.companyName
        self.symbolLabel.text = stocksModel.symbol
        self.priceLabel.text = stocksModel.priceString
        self.changeLabel.text = stocksModel.changeString
    }
    //MARK: -Private
    
//
//    fileprivate func performRequest(withURLString urlString: String) {
//        guard let url = URL(string: urlString) else { return }
//        let urlSession = URLSession(configuration: .default)
//        let dataTask = urlSession.dataTask(with: url) { (data, response, error) in
//            if let data = data {
//                if let currentWeather = self.parseJSON(withData: data) {
//                    self.delegate?.updateInterface(self, with: currentWeather)
//                }
//            }
//        }
//        dataTask.resume()
//    }
    
//    fileprivate func parseJSON(withData data: Data) -> CurrentWeather? {
//        let decoder = JSONDecoder()
//        do {
//            let currentWeatherData = try decoder.decode(CurrentWeatherData.self, from: data)
//            guard let currentWeather = CurrentWeather(currentWeatherData: currentWeatherData) else {
//                return nil
//            }
//            return currentWeather
//        } catch let error as NSError {
//            print(error.localizedDescription)
//        }
//        return nil
//    }
}

    
   // private func requestQuote(for symbol: String) {
//        let token = "pk_76a4a3d58fe842ebbdaaae3a84f47bf1"
//        guard let url = URL(string: "https://cloud.iexapis.com/stable/stock/\(symbol)/quote?token=\(token)") else {
//            return
//        }
//        let dataTask = URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
//            if let data = data,
//               (response as? HTTPURLResponse)?.statusCode == 200,
//               error == nil {
//                self?.parseQuote(from: data)
//            } else {
//                print("Network error!")
//            }
//        }
//        dataTask.resume()
//    }
//
//
//
//    private func parseQuote(from data: Data) {
//        do {
//            let jsonObject = try JSONSerialization.jsonObject(with: data)
//
//            guard
//                let json = jsonObject as? [String: Any],
//                let companyName = json["CompanyName"] as? String else { return print("Invalid JSON") }
//
//            DispatchQueue.main.async { [weak self] in
//                self?.displayStockInfo(companyName: companyName)
//            }
//
//            print("Company name is: " + companyName)
//        } catch {
//            print("JSON parsing error" + error.localizedDescription)
//        }
//    }
//    private func displayStockInfo(companyName: String) {
//        activityIndicator.stopAnimating()
//        companyNameLabel.text = companyName
//    }
//}
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
        activityIndicator.startAnimating()
        
    let selectedSymbol = Array(companies.values)[row]
        
        stocksManager.fetchCurrentStocksWith(symbol: selectedSymbol) { (result) in
            switch result {
            case .Success(let stocksModel):
                self.updateUIWith(stocksModel: stocksModel)
            case .Failure(let error as NSError):
                
                let alertController = UIAlertController(title: "Unable to get data ", message: "\(error.localizedDescription)", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertController.addAction(okAction)
                
                self.present(alertController, animated: true, completion: nil)
              default: break
            }
        }
    }
    
}

