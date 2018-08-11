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
	func didAddEntry(_ entry: CostSheetEntry)
	func didUpdateEntryWithId(_ id: String, with updatedEntry: CostSheetEntry)
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
	var oldEntry: CostSheetEntry?

	// MARK: UIViewController functions
    override func viewDidLoad() {
        super.viewDidLoad()

		entryDatePicker.delegate = self
//		updateDateView(date: entryDatePicker.datePicker.date)

		entryCategoryPicker.delegate = self
//		updateCategoryView(category: CommonUtil.getAllCategories()[0])
    }

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)

		if oldEntry != nil {
			updateViewsForOldEntry()
		} else {
			updateViewsToDefaultValues()
		}
	}

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)

		categoryPickerHeightConstraint.constant = view.frame.size.height - view.safeAreaInsets.bottom - (descriptionTextView.frame.origin.y + descriptionTextView.frame.size.height)
		datePickerHeightConstraint.constant = categoryPickerHeightConstraint.constant
	}

	// MARK: View functions
	private func updateViewsForOldEntry() {
		guard let oldEntry = oldEntry,
			let oldEntryDate = oldEntry.date.date else {
				assertionFailure()
				return
		}
		entryType = oldEntry.type
		updateViewsBasedOnEntryType()
		amountTextView.text = String(oldEntry.amount)
		updateCategoryViews(category: oldEntry.category)
		updateDateViews(date: oldEntryDate)
		descriptionTextView.text = oldEntry.description_p
	}

	private func updateViewsToDefaultValues() {
		updateViewsBasedOnEntryType()
		amountTextView.text = "0.00"
		updateCategoryViews(category: nil)
		updateDateViews(date: Date())
		descriptionTextView.text = "Description"
	}

	private func updateViewsBasedOnEntryType() {
		switch entryType {
		case .expense:
			navigationBarTitleButton.setTitle("Expense", for: .normal)
			navigationBarTitleButton.setTitleColor(ExpenseColor, for: .normal)
			amountBarView.backgroundColor = ExpenseColor
		case .income:
			navigationBarTitleButton.setTitle("Income", for: .normal)
			navigationBarTitleButton.setTitleColor(IncomeColor, for: .normal)
			amountBarView.backgroundColor = IncomeColor
		}
	}

	private func updateDateViews(date: Date) {
		if Calendar.current.isDateInToday(date) {
			dateLabel.text = "Today"
		} else {
			dateLabel.text = date.string(format: "dd-MMM-yyyy")
		}
		timeLabel.text = date.string(format: "hh:mm a")
		entryDatePicker.datePicker.date = date
	}

	private func updateCategoryViews(category: CostSheetEntry.Category?) {
		if let category = category {
			entryCategoryPicker.selectCategory(category)
		} else {
			entryCategoryPicker.categoryPickerView.selectRow(0, inComponent: 0, animated: false)
		}
		categoryLabel.text = entryCategoryPicker.selectedCategory.name
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
		updateViewsBasedOnEntryType()
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
		let amount = Float(amountTextView.text)!
		let category = entryCategoryPicker.selectedCategory
		let dateData = NSKeyedArchiver.archivedData(withRootObject: entryDatePicker.datePicker.date)
		let descriptionText: String
		if let desctiptionTextViewText = descriptionTextView.text {
			descriptionText = desctiptionTextViewText
		} else  {
			descriptionText = ""
		}

		if let oldEntry = oldEntry {
			var entry = oldEntry
			entry.type = entryType
			entry.amount = amount
			entry.category = category
			entry.date = dateData
			entry.description_p = descriptionText
			delegate?.didUpdateEntryWithId(entry.id, with: entry)
		} else {
			var entry = CostSheetEntry()
			entry.id = UUID().uuidString
			entry.type = entryType
			entry.amount = amount
			entry.category = category
			entry.date = dateData
			entry.description_p = descriptionText
			delegate?.didAddEntry(entry)
		}

		oldEntry = nil
		navigationController?.popViewController(animated: true)
	}

}

// MARK: EntryDatePickerDelegate
extension CostSheetEntryViewController: EntryDatePickerDelegate {

	func dateChanged(to date: Date) {
		updateDateViews(date: date)
	}

}

// MARK: EntryCategoryPickerDelegate
extension CostSheetEntryViewController: EntryCategoryPickerDelegate {

	func categoryChanged(to category: CostSheetEntry.Category) {
		updateCategoryViews(category: category)
	}

}
