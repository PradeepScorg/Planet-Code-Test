//
//  NetworkManager.swift
//  Planets
//
//  Created by Pradeep K. Deshmukh on 05/01/19.
//  Copyright © 2019 Pradeep K. Deshmukh. All rights reserved.
//

import Foundation

class NetworkManager {
    
    class func fetchPlanets(with url: String, completion: @escaping (_ data: Any?, _ error: Error?) -> Void) {
        
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { (data, response, error) -> Void in
            //print(response)
            completion(data, error)
        })
        
        task.resume()
    }
}
