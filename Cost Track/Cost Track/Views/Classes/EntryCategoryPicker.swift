//
//  EntryCategoryPicker.swift
//  Cost Track
//
//  Created by Karthik M S on 05/08/18.
//  Copyright © 2018 Karthik M S. All rights reserved.
//

import UIKit

protocol EntryCategoryPickerDelegate: class {
	func categoryChanged(to category: CostSheetEntry.Category)
}

class EntryCategoryPicker: UIView {

	// MARK: IBOutlets
	@IBOutlet var contentView: UIView!
	@IBOutlet weak var categoryPickerView: UIPickerView!

	// MARK: Properties
	weak var delegate: EntryCategoryPickerDelegate?
	private let categories = CommonUtil.getAllCategories()

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

}

// MARK: UIPickerViewDataSource
extension EntryCategoryPicker: UIPickerViewDataSource {

	func numberOfComponents(in pickerView: UIPickerView) -> Int {
		return 1
	}

	func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		return categories.count
	}
		
}

extension EntryCategoryPicker: UIPickerViewDelegate {

	func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		return categories[row].name
	}

	func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
		delegate?.categoryChanged(to: categories[row])
	}

}
