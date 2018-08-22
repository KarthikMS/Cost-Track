//
//  Account+Util.swift
//  Cost Track
//
//  Created by Karthik M S on 29/07/18.
//  Copyright © 2018 Karthik M S. All rights reserved.
//

import Foundation

extension Account {

	func numberOfCostSheetsInGroup(_ group: CostSheetGroup) -> Int {
		var count = 0
		for costSheet in costSheets where costSheet.group.id == group.id {
			count += 1
		}
		return count
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
			if numberOfCostSheetsInGroup(group) > 0 {
				groupsWithCostSheets.append(group)
			}
		}
		return groupsWithCostSheets
	}

	var hasCostSheetsInOtherGroups: Bool {
		for costSheet in costSheets where costSheet.group.id != NotSetGroupID {
			return true
		}
		return false
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

}
