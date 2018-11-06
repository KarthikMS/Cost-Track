//
//  AccountingPeriodViewController.swift
//  Cost Track
//
//  Created by Karthik M S on 06/11/18.
//  Copyright © 2018 Karthik M S. All rights reserved.
//

import UIKit

enum AccountingPeriod {
	case day
	case week
	case month
	case year
	case all
}

protocol AccountingPeriodViewControllerDelegate: class {
	func cancelButtonPressed()
	func accountingPeriodChanged()
}

class AccountingPeriodViewController: UIViewController {

	// MARK: IBOutlets
	@IBOutlet private weak var tableView: UITableView!
	@IBOutlet private weak var segmentedControl: UISegmentedControl!

	// MARK: Properties
	weak var delegate: AccountingPeriodViewControllerDelegate!
	var accountingPeriod = AccountingPeriod.all
	private var shouldCarryOver = true
	private var shouldShowMonthStartDaySelector = false
	private let startDayLabel = UILabel()

	// MARK: UIViewController functions
	override func viewDidLoad() {
		super.viewDidLoad()

		shouldCarryOver = UserDefaults.standard.value(forKey: BalanceCarryOver) as! Bool

		addShadow()

		var startDayLabelFrame = CGRect()
		startDayLabelFrame.origin = CGPoint.zero
		startDayLabelFrame.size.height = 70
		startDayLabelFrame.size.width = 70
		startDayLabel.frame = startDayLabelFrame
		startDayLabel.textColor = .darkGray
		startDayLabel.textAlignment = .right

		tableView.register(UITableViewCell.self, forCellReuseIdentifier: "AccountingPeriodCell")
		tableView.isScrollEnabled = false
	}

	private func addShadow() {
		let shadowPath = UIBezierPath(rect: view.bounds)
		view.layer.shadowPath = shadowPath.cgPath
		view.layer.masksToBounds = false
		view.layer.shadowColor = UIColor.black.cgColor
		view.layer.shadowOpacity = 0.5
		view.layer.shadowOffset = CGSize(width: 0, height: 0.5)
	}

	@objc
	private func carryOverSwitchTapped(sender: Any) {
		guard let sender = sender as? UISwitch else {
			return
		}
		shouldCarryOver = sender.isOn
	}

	private func adjustFrameForMonth() {
		var frame = view.frame
		frame.size.height += 200
		view.frame = frame
		let shadowPath = UIBezierPath(rect: view.bounds)
		view.layer.shadowPath = shadowPath.cgPath
	}

	private func adjustFrameForOtherAccountingPeriod() {
		var frame = view.frame
		frame.size.height -= 200
		view.frame = frame
		let shadowPath = UIBezierPath(rect: view.bounds)
		view.layer.shadowPath = shadowPath.cgPath
	}

}

// MARK: IBActions
private extension AccountingPeriodViewController {

	@IBAction func cancelButtonPressed(_ sender: Any) {
		adjustFrameForOtherAccountingPeriod()
		delegate.cancelButtonPressed()
	}

	@IBAction func applyButtonPressed(_ sender: Any) {
		UserDefaults.standard.setValue(shouldCarryOver, forKey: BalanceCarryOver)
		UserDefaults.standard.setValue(Int(startDayLabel.text!)!, forKey: StartDayForMonthlyAccountingPeriod)
		adjustFrameForOtherAccountingPeriod()
		delegate.accountingPeriodChanged()
	}

	@IBAction func segmentedControlValueChanged(_ sender: UISegmentedControl) {
		switch sender.selectedSegmentIndex {
		case 0:
			if accountingPeriod == .day {
				return
			}
			if accountingPeriod == .month {
				adjustFrameForOtherAccountingPeriod()
			}
			accountingPeriod = .day
		case 1:
			if accountingPeriod == .week {
				return
			}
			if accountingPeriod == .month {
				adjustFrameForOtherAccountingPeriod()
			}
			accountingPeriod = .week
		case 2:
			if accountingPeriod == .month {
				return
			}
			adjustFrameForMonth()
			accountingPeriod = .month
		case 3:
			if accountingPeriod == .year {
				return
			}
			if accountingPeriod == .month {
				adjustFrameForOtherAccountingPeriod()
			}
			accountingPeriod = .year
		default:
			if accountingPeriod == .all {
				return
			}
			if accountingPeriod == .month {
				adjustFrameForOtherAccountingPeriod()
			}
			accountingPeriod = .all
		}
		shouldShowMonthStartDaySelector = false
		tableView.reloadData()
	}

}

// MARK: UITableViewDataSource
extension AccountingPeriodViewController: UITableViewDataSource {

	func numberOfSections(in tableView: UITableView) -> Int {
		if accountingPeriod == .month {
			return 2
		} else {
			return 1
		}
	}

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 1
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "AccountingPeriodCell", for: indexPath)
		if indexPath.section == 0 {
			cell.textLabel?.text = "Carry Over"

			// Adding UISwitch as accessoryView
			let switchView = UISwitch(frame: CGRect.zero)
			switchView.isOn = shouldCarryOver
			switchView.addTarget(self, action: #selector(carryOverSwitchTapped), for: .valueChanged)
			cell.accessoryView = switchView

			if segmentedControl.selectedSegmentIndex == 4 {
				switchView.isEnabled = false
				cell.textLabel?.textColor = .lightGray
			} else {
				cell.textLabel?.textColor = .darkGray
			}
		} else {
			cell.textLabel?.text = "Month start day:"
			cell.textLabel?.textColor = .darkGray

			startDayLabel.text = String(startDayForMonthlyAccountingPeriod)
			cell.accessoryView = startDayLabel
		}
		return cell
	}

	func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
		if section == 0 {
			return 45
		} else {
			if shouldShowMonthStartDaySelector {
				return 145
			} else {
				return 45
			}
		}
	}

}

// MARK: UITableViewDelegate
extension AccountingPeriodViewController: UITableViewDelegate {

	func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
		if section == 0 {
			let textView = UITextView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width , height: 45))
			textView.text = "Activate this option to carry over the balance from the completed accounting period to the next one."
			textView.textColor = .darkGray
			textView.backgroundColor = TintedWhiteColor
			return textView
		} else {
			var footerViewFrame = CGRect(x: 0, y: 0, width: view.frame.size.width , height: 45)
			var textViewFrame = footerViewFrame
			let footerView = UIView(frame: footerViewFrame)
			footerView.backgroundColor = TintedWhiteColor
			if shouldShowMonthStartDaySelector {
				footerViewFrame.size.height = 145
				footerView.frame = footerViewFrame
				textViewFrame.origin.y = 100

				let startDayPicker = UIPickerView(frame: CGRect(x: 0, y: 10, width: view.frame.size.width
					, height: 90))
				startDayPicker.backgroundColor = .clear
				startDayPicker.dataSource = self
				startDayPicker.selectRow(startDayForMonthlyAccountingPeriod - 1, inComponent: 0, animated: false)
				startDayPicker.delegate = self
				footerView.addSubview(startDayPicker)
			}

			let textView = UITextView(frame: textViewFrame)
			textView.text = "Select the first day of the accounting month."
			textView.textColor = .darkGray
			textView.backgroundColor = .clear
			footerView.addSubview(textView)

			return footerView
		}
	}

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if indexPath.section == 1 {
			shouldShowMonthStartDaySelector = !shouldShowMonthStartDaySelector
			tableView.reloadData()
		}
	}

}

// MARK: UIPickerViewDataSource
extension AccountingPeriodViewController: UIPickerViewDataSource {

	func numberOfComponents(in pickerView: UIPickerView) -> Int {
		return 1
	}

	func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		return 28
	}

}

// MARK: UIPickerViewDelegate
extension AccountingPeriodViewController: UIPickerViewDelegate {

	func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		return String(row + 1)
	}

	func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
		startDayLabel.text = String(row + 1)
	}

}
