//
//  TableViewController.swift
//  Stocks
//
//  Created by Oleg on 1/31/21.
//

import UIKit

class TableViewController: UITableViewController {
    private var allModels = [StocksModel]()
    let loader = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView()
        
        self.tableView.addSubview(loader)
        self.loader.center = tableView.center
        self.loader.hidesWhenStopped = true
        self.loader.startAnimating()
        
        APIStocksManager.shared.fetchAllStocks { [weak self] result in
            switch result {
            case .Success(let stocksModel):
                self?.allModels = stocksModel.sorted(by: { (m1, m2) -> Bool in
                    m1.companyName < m2.companyName
                })
                self?.tableView.reloadData()
            case .Failure(let error as NSError):
                
                let alertController = UIAlertController(title: "Unable to get data ", message: "\(error.localizedDescription)", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertController.addAction(okAction)
                
                self?.present(alertController, animated: true, completion: nil)
            default: break
            }
            self?.loader.stopAnimating()
        }
    }
    
    @IBAction func showOriginalController(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "originalVC")
        self.present(vc, animated: true)
    }
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.allModels.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StocksCell", for: indexPath) as! StockTableViewCell
        let stock = self.allModels[indexPath.row]
        
        cell.configure(with: stock)
        
        return cell
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            
            
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            
            let checkStocks = segue.destination as! CheksTableViewController
            checkStocks.checkStock = self.allModels[indexPath.row]
        }
    }
    
}
