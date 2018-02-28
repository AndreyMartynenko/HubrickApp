//
//  UIImageView+ImageFromUrl.swift
//  HubrickApp
//
//  Created by Andrey on 2/24/18.
//

import UIKit

extension UIImageView {
    public func imageFromUrl(urlString: String?) {
        guard let urlString = urlString else {
            print("__UIImageView+ImageFromUrl: provided URL is empty")
            return
        }
        
        URLSession.shared.dataTask(with: NSURL(string: urlString)! as URL, completionHandler: { (data, response, error) -> Void in
            if let error = error {
                print("__UIImageView+ImageFromUrl: \(error.localizedDescription)")
                return
            }
            
            DispatchQueue.main.async(execute: { () -> Void in
                let image = UIImage(data: data!)
                self.image = image
            })
            
        }).resume()
    }
}
