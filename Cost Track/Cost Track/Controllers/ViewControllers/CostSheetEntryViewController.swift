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
	var category = CostSheetEntry.Categoty.fuel

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

	@IBAction func saveButtonPressed(_ sender: Any) {
		var newEntry = CostSheetEntry()
		newEntry.amount = Float(amountTextView.text)!
		newEntry.category = category

		let currentDate = Date()
		let dateData = NSKeyedArchiver.archivedData(withRootObject: currentDate)
		newEntry.date = dateData


		print("Entry created")
		if let date = NSKeyedUnarchiver.unarchiveObject(with: newEntry.date) as? Date {
			let dateFormatter = DateFormatter()
			dateFormatter.locale = Locale.current
			dateFormatter.dateFormat = "EEE dd, MMM yyyy   HH:mm:ss"
			print(dateFormatter.string(from: date))
		}

	}

}
