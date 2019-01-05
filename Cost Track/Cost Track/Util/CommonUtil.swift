//
//  CommonUtil.swift
//  Cost Track
//
//  Created by Karthik M S on 03/11/18.
//  Copyright © 2018 Karthik M S. All rights reserved.
//

import UIKit

protocol CostSheetDataSource: class {
	var document: Document { get }
	var costSheetId: String { get }
}

extension UIViewController {

	func showAlertSaying(_ message: String) {
		let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
		let okAction = UIAlertAction(title: "Ok", style: .default) { (_) in
			alertController.dismiss(animated: true)
		}
		alertController.addAction(okAction)
		present(alertController, animated: true)
	}

}

protocol DataConvertible {
	init?(data: Data)
	var data: Data { get }
}

extension DataConvertible {

	init?(data: Data) {
		guard data.count == MemoryLayout<Self>.size else { return nil }
		self = data.withUnsafeBytes { $0.pointee }
	}

	var data: Data {
		return withUnsafeBytes(of: self) { Data($0) }
	}
}

extension Float : DataConvertible { }
extension Bool : DataConvertible { }

var startDayForMonthlyAccountingPeriod: Int {
	if UserDefaults.standard.value(forKey: StartDayForMonthlyAccountingPeriod) == nil {
		UserDefaults.standard.setValue(1, forKey: StartDayForMonthlyAccountingPeriod)
	}
	return UserDefaults.standard.value(forKey: StartDayForMonthlyAccountingPeriod) as! Int
}

var shouldCarryOverBalance: Bool {
	if UserDefaults.standard.value(forKey: BalanceCarryOver) == nil {
		UserDefaults.standard.setValue(true, forKey: BalanceCarryOver)
	}
	return UserDefaults.standard.value(forKey: BalanceCarryOver) as! Bool
}

// MARK: Accounting period
var accountingPeriodFormat: Int {
	if UserDefaults.standard.value(forKey: AccountingPeriodFormat) == nil {
		UserDefaults.standard.setValue(4, forKey: AccountingPeriodFormat)
	}
	return UserDefaults.standard.value(forKey: AccountingPeriodFormat) as! Int
}

var accountingPeriodDateRange: (startDate: Date, endDate: Date)? {
	let now = Date()
	switch AccountingPeriod(rawValue: accountingPeriodFormat)! {
	case .day:
		return (now, now)
	case .week:
		return now.startAndEndDatesOfWeek()
	case .month:
		return now.startAndEndDatesAMonthApart(startDay: startDayForMonthlyAccountingPeriod)
	case .year:
		return now.startAndEndDatesOfYear()
	case .all:
		return nil
	}
}

var accountingPeriodNavigationBarLabelText: String {
	switch AccountingPeriod(rawValue: accountingPeriodFormat)! {
	case .day:
		return Date().string(format: "dd/MM/yy")
	case .week:
		let (startDate, endDate) = Date().startAndEndDatesOfWeek()
		return "\(startDate.string(format: "dd MMM")) - \(endDate.string(format: "dd MMM"))"
	case .month:
		let now = Date()
		if startDayForMonthlyAccountingPeriod == 1 {
			return "\(now.string(format: "MMMM yyyy"))"
		} else {
			let (startDate, endDate) = now.startAndEndDatesAMonthApart(startDay: startDayForMonthlyAccountingPeriod)
			return "\(startDate.string(format: "dd MMM")) - \(endDate.string(format: "dd MMM"))"
		}
	case .year:
		return Date().string(format: "yyyy")
	case .all:
		return "At all times"
	}
}
