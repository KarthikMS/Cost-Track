//
//  CostSheetEntryViewController.swift
//  Cost Track
//
//  Created by Karthik M S on 18/07/18.
//  Copyright © 2018 Karthik M S. All rights reserved.
//

import UIKit

// TODO: Delete once saving protos has been added
protocol CostSheetEntryDelegate {
	func entryAdded(_ entry: CostSheetEntry)
}

class CostSheetEntryViewController: UIViewController {

	// MARK: IBOutlets
	// Views
	@IBOutlet weak var navigationBarTitleButton: UIButton!
	@IBOutlet weak var amountBarView: UIView!
	@IBOutlet weak var amountTextView: UITextView!
	@IBOutlet weak var categoryLabel: UILabel!
	@IBOutlet weak var dateLabel: UILabel!
	@IBOutlet weak var timeLabel: UILabel!
	@IBOutlet weak var descriptionTextView: UITextView!
	@IBOutlet weak var entryDatePicker: EntryDatePicker!
	@IBOutlet weak var entryCategoryPicker: EntryCategoryPicker!

	// Constraints
	@IBOutlet weak var categoryPickerHeightConstraint: NSLayoutConstraint!
	@IBOutlet weak var categoryPickerHideTopConstraint: NSLayoutConstraint!
	@IBOutlet weak var categoryPickerShowTopConstraint: NSLayoutConstraint!

	@IBOutlet weak var datePickerHeightConstraint: NSLayoutConstraint!
	@IBOutlet weak var datePickerHideTopConstraint: NSLayoutConstraint!
	@IBOutlet weak var datePickerShowTopConstraint: NSLayoutConstraint!

	// MARK: Properties
	// TODO: Delete once saving protos has been added
	var delegate: CostSheetEntryDelegate?
	var entryType = CostSheetEntry.EntryType.income
//	var costSheet: CostSheet?

	// MARK: UIViewController functions
    override func viewDidLoad() {
        super.viewDidLoad()

		// Set amountBar text color

		entryDatePicker.delegate = self
		updateDateView(date: entryDatePicker.datePicker.date)

		entryCategoryPicker.delegate = self
		updateCategoryView(category: CommonUtil.getAllCategories()[0])
    }

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)

		categoryPickerHeightConstraint.constant = view.frame.size.height - view.safeAreaInsets.bottom - (descriptionTextView.frame.origin.y + descriptionTextView.frame.size.height)
		datePickerHeightConstraint.constant = categoryPickerHeightConstraint.constant
	}

	// MARK: View functions
	private func updateNavigationBarButton() {
		switch entryType {
		case .expense:
			navigationBarTitleButton.setTitle("Expense", for: .normal)
			navigationBarTitleButton.setTitleColor(ExpenseColor, for: .normal)
		case .income:
			navigationBarTitleButton.setTitle("Income", for: .normal)
			navigationBarTitleButton.setTitleColor(IncomeColor, for: .normal)
		}
	}

	private func updateDateView(date: Date) {
		if Calendar.current.isDateInToday(date) {
			dateLabel.text = "Today"
		} else {
			dateLabel.text = date.string(format: "dd-MMM-yyyy")
		}
		timeLabel.text = date.string(format: "hh:mm a")
	}

	private func updateCategoryView(category: CostSheetEntry.Category) {
		categoryLabel.text = category.name
	}

	private func showCategoryPicker() {
		if categoryPickerShowTopConstraint.isActive {
			return
		}

		view.removeConstraint(categoryPickerHideTopConstraint)
		view.addConstraint(categoryPickerShowTopConstraint)
		UIView.animate(withDuration: 0.75) {
			self.view.layoutIfNeeded()
		}
	}

	private func hideCategoryPicker() {
		if categoryPickerHideTopConstraint.isActive {
			return
		}

		view.removeConstraint(categoryPickerShowTopConstraint)
		view.addConstraint(categoryPickerHideTopConstraint)
		UIView.animate(withDuration: 0.75) {
			self.view.layoutIfNeeded()
		}
	}

	private func showDatePicker() {
		if datePickerShowTopConstraint.isActive {
			return
		}

		view.removeConstraint(datePickerHideTopConstraint)
		view.addConstraint(datePickerShowTopConstraint)
		UIView.animate(withDuration: 0.75) {
			self.view.layoutIfNeeded()
		}
	}

	private func hideDatePicker() {
		if datePickerHideTopConstraint.isActive {
			return
		}

		view.removeConstraint(datePickerShowTopConstraint)
		view.addConstraint(datePickerHideTopConstraint)
		UIView.animate(withDuration: 0.75) {
			self.view.layoutIfNeeded()
		}
	}

}

// MARK: IBActions
extension CostSheetEntryViewController {

	@IBAction func navigationBarTitleButtonPressed(_ sender: UIButton) {
		switch entryType {
		case .income:
			entryType = .expense
		case .expense:
			entryType = .income
		}
		updateNavigationBarButton()
	}

	@IBAction func currencyButtonPressed(_ sender: Any) {
		amountTextView.resignFirstResponder()
		descriptionTextView.resignFirstResponder()
	}

	@IBAction func categoryViewTapped(_ sender: Any) {
		amountTextView.resignFirstResponder()
		descriptionTextView.resignFirstResponder()

		hideDatePicker()
		showCategoryPicker()
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

		hideCategoryPicker()
		showDatePicker()
	}

	@IBAction func saveButtonPressed(_ sender: Any) {
		var newEntry = CostSheetEntry()
		newEntry.type = entryType
		newEntry.amount = Float(amountTextView.text)!
		newEntry.category = entryCategoryPicker.selectedCategory

		let entryDate = entryDatePicker.datePicker.date
		let dateData = NSKeyedArchiver.archivedData(withRootObject: entryDate)
		newEntry.date = dateData

		// TODO: Set entryType
		// TODO: Save the entry

		// TODO: Delete once saving protos has been added
		delegate?.entryAdded(newEntry)
//		costSheet?.entries.append(newEntry)

		navigationController?.popViewController(animated: true)
	}

}

// MARK: EntryDatePickerDelegate
extension CostSheetEntryViewController: EntryDatePickerDelegate {

	func dateChanged(to date: Date) {
		updateDateView(date: date)
	}

}

// MARK: EntryCategoryPickerDelegate
extension CostSheetEntryViewController: EntryCategoryPickerDelegate {

	func categoryChanged(to category: CostSheetEntry.Category) {
		updateCategoryView(category: category)
	}

}
