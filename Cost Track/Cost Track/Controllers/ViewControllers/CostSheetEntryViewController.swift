//
//  CostSheetEntryViewController.swift
//  Cost Track
//
//  Created by Karthik M S on 18/07/18.
//  Copyright © 2018 Karthik M S. All rights reserved.
//

import UIKit

class CostSheetEntryViewController: UIViewController {

	// MARK: IBOutlets
	@IBOutlet weak var amountBarView: UIView!
	@IBOutlet weak var amountTextView: UITextView!
	@IBOutlet weak var descriptionTextView: UITextView!

	// MARK: Properties
	let SalaryColor = UIColor(red: 102/255.0, green: 255/255.0, blue: 102/255.0, alpha: 1)
	let ExpenseColor = UIColor(red: 255/255.0, green: 102/255.0, blue: 102/255.0, alpha: 1)

	// MARK: UIViewController functions
    override func viewDidLoad() {
        super.viewDidLoad()

		// Set amountBar text color
    }

}

// MARK: IBActions
extension CostSheetEntryViewController {

	@IBAction func currencyButtonPressed(_ sender: Any) {
	}

	@IBAction func categoryButtonPressed(_ sender: Any) {
		print("Cat")
	}

	@IBAction func locationButtonPressed(_ sender: Any) {
	}

	@IBAction func imageButtonPressed(_ sender: Any) {
	}

	@IBAction func voiceNoteButtonPressed(_ sender: Any) {
	}

	@IBAction func dateButtonPressed(_ sender: Any) {
	}

	@IBAction func repeatButtonPressed(_ sender: Any) {
	}

}
