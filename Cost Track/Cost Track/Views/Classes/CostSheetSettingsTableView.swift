//
//  CostSheetSettingsTableView.swift
//  Cost Track
//
//  Created by Karthik M S on 15/07/18.
//  Copyright © 2018 Karthik M S. All rights reserved.
//

import UIKit

enum CostSheetSettingsTableViewMode {
	case newCostSheet
	case costSheetSettings
}

class CostSheetSettingsTableView: UITableView {

	// MARK: Properties
	private var mode = CostSheetSettingsTableViewMode.newCostSheet

	// Views
	var costSheetNameTextView = UITextView()
	var initalBalanceTextView = UITextView()

	// MARK: Functions
	func setMode(_ mode: CostSheetSettingsTableViewMode) {
		self.mode = mode

		separatorInset.left = 0
		register(UITableViewCell.self, forCellReuseIdentifier: "CostSheetSettingsTableViewCell")
		dataSource = self
		delegate = self
	}

}

// MARK: UITableViewDataSource
extension CostSheetSettingsTableView: UITableViewDataSource {

	func numberOfSections(in tableView: UITableView) -> Int {
		switch mode {
		case .newCostSheet:
			return 5
		case .costSheetSettings:
			return 6
		}
	}

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 1
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "CostSheetSettingsTableViewCell", for: indexPath)
		switch indexPath.section {
		case 0:
			cell.textLabel?.text = "Cost sheet"
			cell.addAccessoryTextView(withText: "Cost Sheet")
			costSheetNameTextView = cell.accessoryView as! UITextView
		case 1:
			cell.textLabel?.text = "Currency"
		case 2:
			cell.textLabel?.text = "Initial balance"
			cell.addAccessoryTextView(withText: "0.00", keyboardType: .decimalPad)
			initalBalanceTextView = cell.accessoryView as! UITextView
		case 3:
			cell.textLabel?.text = "Overall Total"
		case 4:
			cell.textLabel?.text = "Group"
		default:
			cell.textLabel?.text = "Export Sheet"
		}

		return cell
	}

}

// MARK: UITableViewDelegate
extension CostSheetSettingsTableView: UITableViewDelegate {

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		// To dismiss the keyboard
		endEditing(true)
	}

}

private extension UITableViewCell {

	func addAccessoryTextView(withText: String, keyboardType: UIKeyboardType = .default) {
		let contentViewFrame = contentView.frame
		var frame = CGRect()
		frame.size.width = 0.6 * contentViewFrame.size.width
		frame.size.height = contentViewFrame.size.height
		frame.origin.x = contentViewFrame.size.width - frame.size.width
		frame.origin.y = 0

		let textView = UITextView(frame: frame)
		textView.keyboardType = keyboardType
		textView.backgroundColor = .red

		accessoryView = textView
	}

}
