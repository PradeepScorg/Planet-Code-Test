//
//  ProgressViewController.swift
//  Planets
//
//  Created by Pradeep K. Deshmukh on 05/01/19.
//  Copyright © 2019 Pradeep K. Deshmukh. All rights reserved.
//

import UIKit

class ProgressViewController: UIViewController {
    
    @IBOutlet var indicator: UIActivityIndicatorView!
    
    // MARK: - ViewController Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.indicator.startAnimating()
        NotificationCenter.default.addObserver(self, selector: #selector(self.hideProgressIndicator), name: NSNotification.Name(rawValue: "hideProgress"), object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "hideProgress"), object: nil)
    }
    
    // MARK: - Progerss Indicator Methods
    // Hide progress bar
    @objc func hideProgressIndicator() {
        self.indicator.stopAnimating()
        self.dismiss(animated: false, completion: nil)
    }
    
}

