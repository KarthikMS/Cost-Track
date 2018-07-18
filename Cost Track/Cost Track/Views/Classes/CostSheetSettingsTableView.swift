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

	// Properties
	private var mode = CostSheetSettingsTableViewMode.newCostSheet

	func setMode(_ mode: CostSheetSettingsTableViewMode) {
		self.mode = mode

		separatorInset.left = 0
		register(UITableViewCell.self, forCellReuseIdentifier: "CostSheetSettingsTableViewCell")
		dataSource = self
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
		case 1:
			cell.textLabel?.text = "Currency"
		case 2:
			cell.textLabel?.text = "Initial balance"
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

private extension UITableViewCell {

	func addAccessoryTextView(withText: String) {
		let contentViewFrame = contentView.frame
		var frame = CGRect()
		frame.size.width = 0.6 * contentViewFrame.size.width
		frame.size.height = contentViewFrame.size.height
		frame.origin.x = contentViewFrame.size.width - frame.size.width
		frame.origin.y = 0

		let textView = UITextView(frame: frame)
		textView.backgroundColor = .red

		accessoryView = textView
	}

}
