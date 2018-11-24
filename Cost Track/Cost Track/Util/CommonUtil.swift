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
	return UserDefaults.standard.value(forKey: StartDayForMonthlyAccountingPeriod) as! Int
}

var shouldCarryOverBalance: Bool {
	return UserDefaults.standard.value(forKey: BalanceCarryOver) as! Bool
}

var accountingPeriodFormat: Int {
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
