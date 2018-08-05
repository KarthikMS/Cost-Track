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
	@IBOutlet weak var dateLabel: UILabel!
	@IBOutlet weak var timeLabel: UILabel!
	@IBOutlet weak var descriptionTextView: UITextView!
	@IBOutlet weak var entryDatePicker: EntryDatePicker!

	// MARK: Properties
	var category = CostSheetEntry.Category.entertainment

	// MARK: UIViewController functions
    override func viewDidLoad() {
        super.viewDidLoad()

		// Set amountBar text color

		entryDatePicker.delegate = self
		updateDateView(date: entryDatePicker.datePicker.date)
    }

	// MARK: View functions
	private func updateDateView(date: Date) {
		if Calendar.current.isDateInToday(date) {
			dateLabel.text = "Today"
		} else {
			dateLabel.text = date.string(format: "dd-MMM-yyyy")
		}
		timeLabel.text = date.string(format: "hh:mm a")
	}
}

// MARK: IBActions
extension CostSheetEntryViewController {

	@IBAction func currencyButtonPressed(_ sender: Any) {
		amountTextView.resignFirstResponder()
		descriptionTextView.resignFirstResponder()
	}

	@IBAction func categoryButtonPressed(_ sender: Any) {
		amountTextView.resignFirstResponder()
		descriptionTextView.resignFirstResponder()
	}

	@IBAction func locationButtonPressed(_ sender: Any) {
		amountTextView.resignFirstResponder()
		descriptionTextView.resignFirstResponder()
	}

	@IBAction func imageButtonPressed(_ sender: Any) {
		amountTextView.resignFirstResponder()
		descriptionTextView.resignFirstResponder()
	}

	@IBAction func voiceNoteButtonPressed(_ sender: Any) {
		amountTextView.resignFirstResponder()
		descriptionTextView.resignFirstResponder()
	}

	@IBAction func dateViewTapped(_ sender: Any) {
		amountTextView.resignFirstResponder()
		descriptionTextView.resignFirstResponder()
	}

	@IBAction func repeatButtonPressed(_ sender: Any) {
		amountTextView.resignFirstResponder()
		descriptionTextView.resignFirstResponder()
	}

	@IBAction func saveButtonPressed(_ sender: Any) {
		var newEntry = CostSheetEntry()
		newEntry.amount = Float(amountTextView.text)!
		newEntry.category = category

		let entryDate = entryDatePicker.datePicker.date
		let dateData = NSKeyedArchiver.archivedData(withRootObject: entryDate)
		newEntry.date = dateData
	}

}

// MARK: EntryDatePickerDelegate
extension CostSheetEntryViewController: EntryDatePickerDelegate {

	func dateChanged(to date: Date) {
		updateDateView(date: date)
	}

}
