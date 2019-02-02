//
//  EntryCategoryPicker.swift
//  Cost Track
//
//  Created by Karthik M S on 05/08/18.
//  Copyright © 2018 Karthik M S. All rights reserved.
//

import UIKit

protocol EntryCategoryPickerDataSource: class {
	var categoriesFilteredByEntryType: [Category] { get }
}

protocol EntryCategoryPickerDelegate: class {
	func categoryChanged(to category: Category)
}

class EntryCategoryPicker: UIView {

	// MARK: IBOutlets
	@IBOutlet var contentView: UIView!
	@IBOutlet weak var categoryPickerView: UIPickerView!

	// MARK: Properties
	weak var dataSource: EntryCategoryPickerDataSource?
	weak var delegate: EntryCategoryPickerDelegate?

	// This will contain the last 2 selected rows. Used to get previous selected category.
	private var selectedRows = [0, 0]

	// MARK: Initializers
	override init(frame: CGRect) {
		super.init(frame: frame)
		commonInit()
	}

	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		commonInit()
	}

	private func commonInit() {
		Bundle.main.loadNibNamed("EntryCategoryPicker", owner: self, options: nil)
		addSubview(contentView)
		contentView.frame = self.bounds
	}

	// MARK: Functions
	var selectedCategory: Category {
		guard let categories = dataSource?.categoriesFilteredByEntryType else {
			assertionFailure()
			return Category()
		}
		return categories[categoryPickerView.selectedRow(inComponent: 0)]
	}

	func selectCategory(_ categoryToSelect: Category) {
		guard let categories = dataSource?.categoriesFilteredByEntryType else {
			assertionFailure()
			return
		}
		for i in 0..<categories.count {
			let category = categories[i]
			if category == categoryToSelect {
				categoryPickerView.selectRow(i, inComponent: 0, animated: false)
				return
			}
		}
		assertionFailure()
	}

	func selectPreviousCategory() {
		categoryPickerView.selectRow(selectedRows[0], inComponent: 0, animated: false)
	}

}

// MARK: UIPickerViewDataSource
extension EntryCategoryPicker: UIPickerViewDataSource {

	func numberOfComponents(in pickerView: UIPickerView) -> Int {
		return 1
	}

	func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		// TODO: This filtering happens every time. Change the flow.
		guard let categories = dataSource?.categoriesFilteredByEntryType else {
			assertionFailure()
			return -1
		}
		return categories.count
	}
		
}

// MARK: UIPickerViewDelegate
extension EntryCategoryPicker: UIPickerViewDelegate {

	func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		guard let categories = dataSource?.categoriesFilteredByEntryType else {
			assertionFailure()
			return nil
		}
		return categories[row].name
	}

	func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
		guard let categories = dataSource?.categoriesFilteredByEntryType else {
			assertionFailure()
			return
		}
		selectedRows.removeFirst()
		selectedRows.append(row)
		delegate?.categoryChanged(to: categories[row])
	}

}
