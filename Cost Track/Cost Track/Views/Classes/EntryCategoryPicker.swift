//
//  EntryCategoryPicker.swift
//  Cost Track
//
//  Created by Karthik M S on 05/08/18.
//  Copyright © 2018 Karthik M S. All rights reserved.
//

import UIKit

protocol EntryCategoryPickerDataSource: class {
	var categories: [Category] { get }
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
		guard let categories = dataSource?.categories else {
			assertionFailure()
			return Category()
		}
		return categories[categoryPickerView.selectedRow(inComponent: 0)]
	}

	func selectCategory(_ categoryToSelect: Category) {
		guard let categories = dataSource?.categories else {
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

}

// MARK: UIPickerViewDataSource
extension EntryCategoryPicker: UIPickerViewDataSource {

	func numberOfComponents(in pickerView: UIPickerView) -> Int {
		return 1
	}

	func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		guard let categories = dataSource?.categories else {
			assertionFailure()
			return -1
		}
		return categories.count
	}
		
}

// MARK: UIPickerViewDelegate
extension EntryCategoryPicker: UIPickerViewDelegate {

	func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		guard let categories = dataSource?.categories else {
			assertionFailure()
			return nil
		}
		return categories[row].name
	}

	func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
		guard let categories = dataSource?.categories else {
			assertionFailure()
			return
		}
		delegate?.categoryChanged(to: categories[row])
	}

}
