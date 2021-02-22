//
//  AsyncImageView.swift
//  Stocks
//
//  Created by Oleg on 1/31/21.
//

import UIKit

class AsyncImageView: UIImageView {
    
    private var currentUrl: String? 
    
    public func imageFromServerURL(url: String){
        currentUrl = url
        //здесь должен быть кэш
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
        let task = session.dataTask(with: NSURL(string: url)! as URL, completionHandler: { [weak self] (data, response, error) -> Void in
            if error == nil {
                DispatchQueue.main.async {
                    if let downloadedImage = UIImage(data: data!) {
                        if (url == self?.currentUrl) {
                            self?.image = downloadedImage
                        }
                    }
                }
            } else {
                print(error)
            }
        })
        task.resume()
    }
}
