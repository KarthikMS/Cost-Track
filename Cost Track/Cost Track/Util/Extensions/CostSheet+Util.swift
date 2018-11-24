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
		var balance = initialBalance
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

	var balanceInAccountingPeriod: Float {
		if shouldCarryOverBalance || AccountingPeriod(rawValue: accountingPeriodFormat)! == .all {
			return self.balance
		}

		var balance: Float = 0
		guard let (startDate, endDate) = accountingPeriodDateRange else {
			assertionFailure()
			return 0
		}
		for entry in entries where entry.date.date!.isBetween(startDate, and: endDate) {
			switch entry.type {
			case .income:
				balance += entry.amount
			case .expense:
				balance -= entry.amount
			}
		}
		return balance
	}

	var entriesInAccountingPeriod: [CostSheetEntry] {
		if AccountingPeriod(rawValue: accountingPeriodFormat)! == .all {
			return entries
		}

		guard let (startDate, endDate) = accountingPeriodDateRange else {
			assertionFailure()
			return entries
		}
		return entries.filter { $0.date.date!.isBetween(startDate, and: endDate) }
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

	var lastModifiedDateString: String {
		guard let date = lastModifiedDate.date else {
			assertionFailure()
			return ""
		}
		let calendar = Calendar.current
		if calendar.isDateInToday(date) {
			return "Today " + date.string(format: "hh:mm a")
		} else if calendar.isDateInYesterday(date) {
			return "Yesterday"
		} else if calendar.isDateInTomorrow(date) {
			return "Tomorrow"
		} else {
			return date.string(format: "dd-MMM-yyyy")
		}
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

	func indexOfEntryWithId(_ id: String) -> Int? {
		for i in 0..<entries.count {
			if entries[i].id == id {
				return i
			}
		}
		return nil
	}

	func entryWithId(_ id: String) -> CostSheetEntry {
		guard let index = indexOfEntryWithId(id) else {
			assertionFailure()
			return CostSheetEntry()
		}
		return entries[index]
	}

	mutating func updateEntry(at index: Int, with updatedEntry: CostSheetEntry) {
		entries[index] = updatedEntry
	}

	mutating func updateEntry(withId id: String, with updatedEntry: CostSheetEntry) {
		guard let index = indexOfEntryWithId(id) else {
			assertionFailure()
			return
		}
		updateEntry(at: index, with: updatedEntry)
	}

	mutating func deleteEntry(withId id: String) {
		guard let index = indexOfEntryWithId(id) else {
			assertionFailure()
			return
		}
		entries.remove(at: index)
	}

}
