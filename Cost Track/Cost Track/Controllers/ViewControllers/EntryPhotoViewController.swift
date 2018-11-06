//
//  EntryPhotoViewController.swift
//  Cost Track
//
//  Created by Karthik M S on 06/11/18.
//  Copyright © 2018 Karthik M S. All rights reserved.
//

import UIKit

class EntryPhotoViewController: UIViewController {

	// MARK: IBOutlets
	@IBOutlet weak var imageView: UIImageView!

}

// MARK: IBActions
private extension EntryPhotoViewController {

	@IBAction func doneButtonPressed(_ sender: Any) {
		dismiss(animated: true)
	}

}
