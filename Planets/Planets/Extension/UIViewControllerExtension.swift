//
//  Extensions.swift
//  Planets
//
//  Created by Pradeep K. Deshmukh on 05/01/19.
//  Copyright © 2019 Pradeep K. Deshmukh. All rights reserved.
//

import UIKit

// MARK: - View Controller extensions
//
extension UIViewController {
    
    // Show Progress bar
    func showProgress() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let progressController = storyboard.instantiateViewController(withIdentifier: "progressIndicator")
        progressController.modalPresentationStyle = .overCurrentContext
        self.present(progressController, animated: false, completion: nil)
    }
    
    // Hide progress bar
    func hideProgress() {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "hideProgress"), object: nil)
    }
    
}
