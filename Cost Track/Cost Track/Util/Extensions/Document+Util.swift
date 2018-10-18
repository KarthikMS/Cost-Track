//
//  Document+Util.swift
//  Cost Track
//
//  Created by Karthik M S on 18/09/18.
//  Copyright © 2018 Karthik M S. All rights reserved.
//

import Foundation

extension Document {

	func costSheetsInGroup(_ group: CostSheetGroup) -> [CostSheet] {
		var costSheetsInGroup = [CostSheet]()
		for costSheet in costSheets where costSheet.group.id == group.id {
			costSheetsInGroup.append(costSheet)
		}
		return costSheetsInGroup
	}

	func numberOfCostSheets(in group: CostSheetGroup) -> Int {
		return costSheetsInGroup(group).count
	}

	func getGroup(withId id: String) -> CostSheetGroup? {
		for group in groups where group.id == id {
			return group
		}
		return nil
	}

	var groupsWithCostSheets: [CostSheetGroup] {
		var groupsWithCostSheets = [CostSheetGroup]()
		for group in groups {
			if costSheetsInGroup(group).count > 0 {
				groupsWithCostSheets.append(group)
			}
		}
		return groupsWithCostSheets
	}

	var hasCostSheetsInOtherGroups: Bool {
		for costSheet in costSheets where costSheet.group.id != NotSetGroup.id {
			return true
		}
		return false
	}

	mutating func moveCostSheets(from fromGroup: CostSheetGroup, to toGroup: CostSheetGroup) {
		for costSheet in costSheetsInGroup(fromGroup) {
			guard let index = indexOfCostSheetWithId(costSheet.id) else {
				assertionFailure()
				return
			}
			costSheets[index].group = toGroup
		}
	}

	var totalAmount: Float {
		var totalAmount: Float = 0
		for costSheet in costSheets {
			totalAmount += costSheet.balance
		}
		return totalAmount
	}

	var defaultNewCostSheetName: String {
		return "Cost Sheet \(costSheets.count + 1)"
	}

	func indexOfCostSheetWithId(_ id: String) -> Int? {
		for i in 0..<costSheets.count {
			if costSheets[i].id == id {
				return i
			}
		}
		return nil
	}

	func costSheetWithId(_ id: String) -> CostSheet {
		guard let index = indexOfCostSheetWithId(id) else {
			assertionFailure()
			return CostSheet()
		}
		return costSheets[index]
	}

	mutating func updateCostSheet(at index: Int, with updatedCostSheet: CostSheet) {
		costSheets[index] = updatedCostSheet
		costSheets[index].lastModifiedDate = Date().data
	}

	mutating func updateCostSheet(withId id: String, with updatedCostSheet: CostSheet) {
		guard let index = indexOfCostSheetWithId(id) else {
			assertionFailure()
			return
		}
		updateCostSheet(at: index, with: updatedCostSheet)
	}

	mutating func deleteCostSheet(withId id: String) {
		guard let index = indexOfCostSheetWithId(id) else {
			assertionFailure()
			return
		}
		costSheets.remove(at: index)
	}

	mutating func deleteCostSheetEntry(withId entryId: String, inCostSheetWithId costSheetId: String) {
		guard let costSheetIndex = indexOfCostSheetWithId(costSheetId),
			let entryIndex = costSheets[costSheetIndex].indexOfEntryWithId(entryId) else {
				assertionFailure()
				return
		}
		costSheets[costSheetIndex].entries.remove(at: entryIndex)
		costSheets[costSheetIndex].lastModifiedDate = Date().data
	}

	mutating func addDefaultCategories() {
		var salary = Category()
		salary.name = "Salary"
		salary.iconType = .salary

		var vehicleAndTransport = Category()
		vehicleAndTransport.name = "Vehicle & Transport"
		vehicleAndTransport.iconType = .vehicleAndTransport

		var household = Category()
		household.name = "Household"
		household.iconType = .household

		var shopping = Category()
		shopping.name = "Shopping"
		shopping.iconType = .shopping

		var phone = Category()
		phone.name = "Phone"
		phone.iconType = .phone

		var entertainment = Category()
		entertainment.name = "Entertainment"
		entertainment.iconType = .entertainment

		var medicine = Category()
		medicine.name = "Medicine"
		medicine.iconType = .medicine

		var investment = Category()
		investment.name = "Investment"
		investment.iconType = .investment

		var investmentReturn = Category()
		investmentReturn.name = "Investment Return"
		investmentReturn.iconType = .investmentReturn

		var tax = Category()
		tax.name = "Tax"
		tax.iconType = .tax

		var insurance = Category()
		insurance.name = "Insurance"
		insurance.iconType = .insurance

		var foodAndDrinks = Category()
		foodAndDrinks.name = "Food & Drinks"
		foodAndDrinks.iconType = .foodAndDrinks

		var misc = Category()
		misc.name = "Misc"
		misc.iconType = .misc

		var transfer = Category()
		transfer.name = "Transfer"
		transfer.iconType = .transfer

		categories.append(contentsOf: [
			salary,
			vehicleAndTransport,
			household,
			shopping,
			phone,

			entertainment,
			medicine,
			investment,
			investmentReturn,
			tax,

			insurance,
			foodAndDrinks,
			misc,
			transfer
			])
	}

}
