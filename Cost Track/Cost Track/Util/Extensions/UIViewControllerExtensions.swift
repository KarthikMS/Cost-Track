//
//  UIViewControllerExtensions.swift
//  Cost Track
//
//  Created by Karthik M S on 21/10/18.
//  Copyright © 2018 Karthik M S. All rights reserved.
//

import UIKit

extension UIViewController {

	func showAlertSaying(_ message: String) {
		let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
		let okAction = UIAlertAction(title: "Ok", style: .default) { (_) in
			alertController.dismiss(animated: true)
		}
		alertController.addAction(okAction)
		present(alertController, animated: true)
	}

}
