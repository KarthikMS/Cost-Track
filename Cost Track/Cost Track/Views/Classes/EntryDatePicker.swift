//
//  EntryDatePicker.swift
//  Cost Track
//
//  Created by Karthik M S on 05/08/18.
//  Copyright © 2018 Karthik M S. All rights reserved.
//

import UIKit

protocol EntryDatePickerDelegate: class {
	func dateChanged(to date: Date)
}

class EntryDatePicker: UIView {

	// MARK: IBOutlets
	@IBOutlet var contentView: UIView!
	@IBOutlet weak var datePicker: UIDatePicker!

	// MARK: Properties
	weak var delegate: EntryDatePickerDelegate?

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
		Bundle.main.loadNibNamed("EntryDatePicker", owner: self, options: nil)
		addSubview(contentView)
		contentView.frame = self.bounds
	}

	func setValueToToday() {
		datePicker.date = Date()
	}

}

// MARK: IBActions
private extension EntryDatePicker {

	@IBAction func segmentedControlValueChanged(_ sender: UISegmentedControl) {
		switch sender.selectedSegmentIndex {
		case 0:
			datePicker.datePickerMode = .dateAndTime
		case 1:
			datePicker.datePickerMode = .date
		default:
			datePicker.datePickerMode = .time
		}
	}

	@IBAction func datePickerValueChanged(_ sender: UIDatePicker) {
		delegate?.dateChanged(to: sender.date)
	}

}
