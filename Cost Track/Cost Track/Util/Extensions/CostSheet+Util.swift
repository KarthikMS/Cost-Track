//
//  CostSheet+Util.swift
//  Cost Track
//
//  Created by Karthik M S on 29/07/18.
//  Copyright © 2018 Karthik M S. All rights reserved.
//

import Foundation

struct IncomeExpenseInfo {
	let incomeCount: Int
	let expenseCount: Int
	let incomeAmount: Float
	let expenseAmount: Float

	init(incomeCount: Int, expenseCount: Int, incomeAmount: Float, expenseAmount: Float) {
		self.incomeCount = incomeCount
		self.expenseCount = expenseCount
		self.incomeAmount = incomeAmount
		self.expenseAmount = expenseAmount
	}
}

extension CostSheet {

	var balance: Float {
		var balance: Float = 0
		for entry in entries {
			switch entry.type {
			case .income:
				balance += entry.amount
			case .expense:
				balance -= entry.amount
			}
		}
		return balance
	}

	var incomeExpenseInfo: IncomeExpenseInfo {
		var incomeCount = 0
		var incomeAmount: Float = 0
		var expenseAmount: Float = 0

		for entry in entries {
			switch entry.type {
			case .income:
				incomeAmount += entry.amount
				incomeCount += 1
			case .expense:
				expenseAmount += entry.amount
			}
		}

		return IncomeExpenseInfo(
			incomeCount: incomeCount,
			expenseCount: entries.count - incomeCount,
			incomeAmount: incomeAmount,
			expenseAmount: expenseAmount
		)
	}

	// Fix this
	var lastModifiedDate: String {
		var lastModifiedDate = ""
		if let entry = entries.first {
			lastModifiedDate = ""//entry.date
		}
		return lastModifiedDate
	}

	func getDateStrings(format: String) -> [String] {
		var dateStrings = [String]()
		for entry in entries {
			guard let date = entry.date.date else {
				assertionFailure()
				return []
			}
			let dateString = date.string(format: format)
			if !dateStrings.contains(dateString) {
				dateStrings.append(dateString)
			}
		}
		return dateStrings
	}
}
