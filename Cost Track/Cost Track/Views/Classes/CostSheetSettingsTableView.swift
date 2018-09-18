//
//  CostSheetSettingsTableView.swift
//  Cost Track
//
//  Created by Karthik M S on 15/07/18.
//  Copyright © 2018 Karthik M S. All rights reserved.
//

import UIKit

protocol CostSheetSettingsTableViewDelegate: class {
	func didSelectGroupCell()
}

enum CostSheetSettingsTableViewMode {
	case newCostSheet
	case costSheetSettings
}

class CostSheetSettingsTableView: UITableView {

	// MARK: Properties
	private var mode = CostSheetSettingsTableViewMode.newCostSheet
	weak var costSheetSettingsTableViewDelegate: CostSheetSettingsTableViewDelegate?
	var costSheet = CostSheet()
	private var footerTextsAndHeights = [(text: String, height: CGFloat)]()
	// Views
	private var costSheetNameTextView = UITextView()
	private var initalBalanceTextView = UITextView()

	// MARK: Functions
	func setMode(_ mode: CostSheetSettingsTableViewMode) {
		self.mode = mode

		costSheet.id = UUID().uuidString
		footerTextsAndHeights = getTextAndHeightsForFooterViews()
		separatorInset.left = 0
		register(UITableViewCell.self, forCellReuseIdentifier: "CostSheetSettingsTableViewCell")
		dataSource = self
		delegate = self
	}

	// MARK: Misc. functions
	func updateCostSheet() {
		costSheet.name = costSheetNameTextView.text
		costSheet.initialBalance = Float(initalBalanceTextView.text)!
	}

	private func getTextAndHeightsForFooterViews() -> [(text: String, height: CGFloat)] {
		var textsAndHeights = [(text: String, height: CGFloat)]()
		let texts = [
			"Enter a cost sheet name for your document (Cash, Debit Card, Bank Account, etc.) or event(Wedding, Summer Holidays, Apartment Renovation, etc.) for which you will track your incomes and expenses.",
			"Select a currency for the cost sheet. Please note that you can convert currencies when entering incomes or expenses.",
			"Initial balance can be positive or negative. It is used for the current sheet balance calculation only.",
			"Define whether you want to include this cost sheet in overall total or not.",
			"Select a group for the cost sheet.",
			"Export the cost sheet in a CSV format."
		]

		let textView = UITextView(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height: 150))
		addSubview(textView)

		for text in texts {
			textView.text = text
			textView.sizeToFit()

			textsAndHeights.append((text: text, height: textView.frame.size.height))
		}

		textView.removeFromSuperview()
		return textsAndHeights
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
		cell.accessoryView = nil
		for subview in cell.contentView.subviews {
			subview.removeFromSuperview()
		}
		switch indexPath.section {
		case 0:
			cell.textLabel?.text = "Cost sheet"
			cell.addAccessoryTextView(costSheetNameTextView)
			cell.selectionStyle = .none
			costSheetNameTextView.text = costSheet.name
		case 1:
			cell.textLabel?.text = "Currency"
		case 2:
			cell.textLabel?.text = "Initial balance"
			cell.addAccessoryTextView(initalBalanceTextView, keyboardType: .decimalPad)
			cell.selectionStyle = .none
			initalBalanceTextView.text = String(costSheet.initialBalance)
		case 3:
			cell.textLabel?.text = "Overall Total"
		case 4:
			cell.textLabel?.text = "Group"
			cell.addAccessoryLabel(text: costSheet.group.name)
		default:
			cell.textLabel?.text = "Export Sheet"
		}

		return cell
	}

}

// MARK: UITableViewDelegate
extension CostSheetSettingsTableView: UITableViewDelegate {

	func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
		let textAndHeight = footerTextsAndHeights[section]

		var frame = CGRect()
		frame.origin.x = 0
		frame.origin.y = 0
		frame.size.width = tableView.frame.size.width
		frame.size.height = textAndHeight.height

		let textView = UITextView(frame: frame)
		textView.backgroundColor = TintedWhiteColor
		textView.text = textAndHeight.text

		return textView
	}

	func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
		return footerTextsAndHeights[section].height
	}

	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return 20
	}

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		// To dismiss the keyboard
		endEditing(true)

		switch indexPath.section {
		case 4:
			costSheetSettingsTableViewDelegate?.didSelectGroupCell()
		default:
			break
		}
		tableView.deselectRow(at: indexPath, animated: true)
	}

}

private extension UITableViewCell {

	func addAccessoryTextView(_ textView: UITextView, keyboardType: UIKeyboardType = .default) {
		let contentViewFrame = contentView.frame
		var frame = CGRect()
		frame.size.width = 0.6 * contentViewFrame.size.width
		frame.size.height = contentViewFrame.size.height
		frame.origin.x = contentViewFrame.size.width - frame.size.width
		frame.origin.y = 0

		textView.frame = frame
		textView.keyboardType = keyboardType
		textView.backgroundColor = .red

		accessoryView = textView
	}

	func addAccessoryLabel(text: String) {
		let contentViewFrame = contentView.frame
		var frame = CGRect()
		frame.size.width = 0.5 * contentViewFrame.size.width
		frame.size.height = contentViewFrame.size.height
		frame.origin.x = 0.4 * contentViewFrame.size.width
		frame.origin.y = 0

		let label = UILabel(frame: frame)
		label.text = text
		label.textAlignment = .right
		contentView.addSubview(label)

		accessoryType = .disclosureIndicator
	}

}
