//
//  EntryDatePicker.swift
//  Cost Track
//
//  Created by Karthik M S on 05/08/18.
//  Copyright © 2018 Karthik M S. All rights reserved.
//

import UIKit

class EntryDatePicker: UIView {

	// MARK: IBOutlets
	@IBOutlet var contentView: UIView!
	@IBOutlet weak var datePicker: UIDatePicker!

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

	@IBAction func datePickerValueChanged(_ sender: UIDatePicker) {
		print(sender.date.string(format: "EEE hh:mm:ss"))
	}
}

// MARK: IBActions
extension EntryDatePicker {

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

}
