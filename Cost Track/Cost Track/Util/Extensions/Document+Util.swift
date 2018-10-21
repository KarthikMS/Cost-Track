//
//  Document+Util.swift
//  Cost Track
//
//  Created by Karthik M S on 18/09/18.
//  Copyright © 2018 Karthik M S. All rights reserved.
//

import Foundation

extension Document {

	static var new: Document {
		var newDoc = Document()

		// Setting NotSetGroup
		NotSetGroup.name = "Not set"
		NotSetGroup.id = UUID().uuidString
		newDoc.groups.append(NotSetGroup)

		newDoc.categories = Category.defaultCategories()
		newDoc.createdOnDate = Date().data

		return newDoc
	}

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

	func costSheetWithId(_ id: String) -> CostSheet? {
		if let index = indexOfCostSheetWithId(id) {
			return costSheets[index]
		}
		return nil
	}

	mutating func updateCostSheet(at index: Int, with updatedCostSheet: CostSheet) {
		costSheets[index] = updatedCostSheet
		costSheets[index].lastModifiedDate = Date().data
	}

	mutating func updateCostSheet(withId id: String, with updatedCostSheet: CostSheet) {
		if let index = indexOfCostSheetWithId(id) {
			updateCostSheet(at: index, with: updatedCostSheet)
		}
	}

	mutating func deleteCostSheet(withId id: String) {
		if let index = indexOfCostSheetWithId(id) {
			costSheets.remove(at: index)
		}
	}

	mutating func deleteCostSheetEntry(withId entryId: String, inCostSheetWithId costSheetId: String) {
		if let costSheetIndex = indexOfCostSheetWithId(costSheetId),
			let entryIndex = costSheets[costSheetIndex].indexOfEntryWithId(entryId) {
			costSheets[costSheetIndex].entries.remove(at: entryIndex)
			costSheets[costSheetIndex].lastModifiedDate = Date().data
		}
	}

}
