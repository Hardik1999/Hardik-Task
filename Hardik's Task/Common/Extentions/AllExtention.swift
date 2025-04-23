//
//  AllExtention.swift
//  Hardik's Task
//
//  Created by Hardik D on 23/04/25.
//

import UIKit


// MARK: String extension
extension String {
    func managedFileName() -> String {
        return self.replacingOccurrences(of: "/", with: "_").replacingOccurrences(of: ":", with: "_")
    }
}

// MARK: Viewcontroller extension
extension UIViewController {
    func showLoader() {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.center = view.center
        activityIndicator.tag = 777
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
    }

    func hideLoader() {
        if let loader = self.view.viewWithTag(777) as? UIActivityIndicatorView {
            loader.stopAnimating()
            loader.removeFromSuperview()
        }
    }
}
