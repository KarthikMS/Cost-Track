//
//  DeltaUtil.swift
//  Cost Track
//
//  Created by Karthik M S on 03/09/18.
//  Copyright © 2018 Karthik M S. All rights reserved.
//

import Foundation

protocol DeltaDelegate: class {
	func sendDeltaComponents(_ components: [DocumentContentOperation.Component])
}

class DeltaUtil {

	static func getComponent(opType: DocumentContentOperation.Component.OperationType, fieldString: String, oldValue: Data? = nil, newValue: Data? = nil) -> DocumentContentOperation.Component {
		var comp = DocumentContentOperation.Component()
		comp.opType = opType
		comp.fields = fieldString
		switch opType {
		case .insert:
			guard let newValue = newValue else {
				assertionFailure("Insert component should have newValue")
				return comp
			}
			comp.value.inBytes.value = newValue
		case .delete:
			guard let oldValue = oldValue else {
				assertionFailure("Delete component should have oldValue")
				return comp
			}
			comp.value.inBytes.oldValue = oldValue
		case .update:
			guard let oldValue = oldValue,
				let newValue = newValue else {
					assertionFailure("Update component should have oldValue and newValue")
					return comp
			}
			comp.value.inBytes.oldValue = oldValue
			comp.value.inBytes.value = newValue
		default:
			break
		}
		return comp
	}

	static func getComponentToInsertGroup(_ group: CostSheetGroup, in account: Account, at index: Int? = nil) -> DocumentContentOperation.Component {
		var insertIndex: Int
		if let index = index {
			insertIndex = index
		} else {
			insertIndex = account.groups.count
		}
		let fieldString = "2,arr:\(insertIndex)"
		return getComponent(opType: .insert, fieldString: fieldString, newValue: group.safeSerializedData)
	}

	static func getComponentToDeleteGroup(at index: Int, in account: Account) -> DocumentContentOperation.Component {
		let group = account.groups[index]
		let fieldString = "2,arr:\(index)"
		return getComponent(opType: .delete, fieldString: fieldString, oldValue: group.safeSerializedData)
	}

	static func getComponentToInsertCostSheet(_ costSheet: CostSheet, in account: Account, at index: Int? = nil) -> DocumentContentOperation.Component {
		var insertIndex: Int
		if let index = index {
			insertIndex = index
		} else {
			insertIndex = account.costSheets.count
		}
		let fieldString = "1,arr:\(insertIndex)"
		return getComponent(opType: .insert, fieldString: fieldString, newValue: costSheet.safeSerializedData)
	}

	static func getComponentToDeleteCostSheet(at index: Int, in account: Account) -> DocumentContentOperation.Component {
		let costSheet = account.costSheets[index]
		let fieldString = "1,arr:\(index)"
		return getComponent(opType: .delete, fieldString: fieldString, oldValue: costSheet.safeSerializedData)
	}

	static func getComponentToUpdateGroupOfCostSheet(at index: Int, from fromGroup: CostSheetGroup, to toGroup: CostSheetGroup, in accout: Account) -> DocumentContentOperation.Component {
		let fieldString = "1,arr:\(index),4"
		return getComponent(
			opType: .update,
			fieldString: fieldString,
			oldValue: fromGroup.safeSerializedData,
			newValue: toGroup.safeSerializedData
		)
	}

	static func getComponentsToMoveCostSheets(from fromGroup: CostSheetGroup, to toGroup: CostSheetGroup, in account: Account) -> [DocumentContentOperation.Component] {
		var comps = [DocumentContentOperation.Component]()
		for i in 0..<account.costSheets.count where account.costSheets[i].group.id == fromGroup.id {
			let updateGroupComp = getComponentToUpdateGroupOfCostSheet(at: i, from: fromGroup, to: toGroup, in: account)
			comps.append(updateGroupComp)
		}
		return comps
	}

	static func getComponentToUpdateEntryWithId(_ entryId: String, with updatedEntry: CostSheetEntry, inCostSheetWithId costSheetId: String, account: Account) -> DocumentContentOperation.Component {
		guard let costSheetIndex = account.indexOfCostSheetWithId(costSheetId) else {
			assertionFailure("Could not get costSheetIndex")
			return DocumentContentOperation.Component()
		}
		let costSheet = account.costSheets[costSheetIndex]
		guard let entryIndex = costSheet.indexOfEntryWithId(entryId) else {
			assertionFailure("Could not get entryIndex")
			return DocumentContentOperation.Component()
		}
		let oldEntry = costSheet.entries[entryIndex]
		let fieldString = "1,arr:\(costSheetIndex),5,arr:\(entryIndex)"
		return getComponent(
			opType: .update,
			fieldString: fieldString,
			oldValue: oldEntry.safeSerializedData,
			newValue: updatedEntry.safeSerializedData
		)
	}

	static func getComponentToInsertEntry(_ newEntry: CostSheetEntry, inCostSheetWithId costSheetId: String, account: Account, at index: Int? = nil) -> DocumentContentOperation.Component {
		guard let costSheetIndex = account.indexOfCostSheetWithId(costSheetId) else {
			assertionFailure("Could not get costSheetIndex")
			return DocumentContentOperation.Component()
		}
		let costSheet = account.costSheets[costSheetIndex]
		let insertIndex: Int
		if let index = index {
			insertIndex = index
		} else {
			insertIndex = costSheet.entries.count
		}
		let fieldString = "1,arr:\(costSheetIndex),5,arr:\(insertIndex)"
		return getComponent(
			opType: .insert,
			fieldString: fieldString,
			newValue: newEntry.safeSerializedData
		)
	}

	static func getComponentToDeleteEntryWithId(_ entryId: String, inCostSheetWithId costSheetId: String, account: Account) -> DocumentContentOperation.Component {
		guard let costSheetIndex = account.indexOfCostSheetWithId(costSheetId) else {
			assertionFailure("Could not get costSheetIndex")
			return DocumentContentOperation.Component()
		}
		let costSheet = account.costSheets[costSheetIndex]
		guard let entryIndex = costSheet.indexOfEntryWithId(entryId) else {
			assertionFailure("Could not get entryIndex")
			return DocumentContentOperation.Component()
		}
		let oldEntry = costSheet.entries[entryIndex]
		let fieldString = "1,arr:\(costSheetIndex),5,arr:\(entryIndex)"
		return getComponent(
			opType: .delete,
			fieldString: fieldString,
			oldValue: oldEntry.safeSerializedData
		)
	}

	static func getComponentsToTransferEntry(withId entryId: String, fromCostSheetWithId fromCostSheetId: String, toCostSheetWithId toCostSheetId: String, account: Account) -> [DocumentContentOperation.Component] {
		guard let fromCostSheetIndex = account.indexOfCostSheetWithId(fromCostSheetId),
		let toCostSheetIndex = account.indexOfCostSheetWithId(toCostSheetId) else {
			assertionFailure("Could not get costSheetIndex")
			return []
		}
		let fromCostSheet = account.costSheets[fromCostSheetIndex]
		let toCostSheet = account.costSheets[toCostSheetIndex]
		guard let entryIndex = fromCostSheet.indexOfEntryWithId(entryId) else {
			assertionFailure("Could not get entryIndex")
			return []
		}
		let entryData = fromCostSheet.entries[entryIndex].safeSerializedData
		let deleteFieldString = "1,arr:\(fromCostSheetIndex),5,arr:\(entryIndex)"
		let insertFieldString =	"1,arr:\(toCostSheetIndex),5,arr:\(toCostSheet.entries.count)"
		let deleteEntryComp = getComponent(
			opType: .delete,
			fieldString: deleteFieldString,
			oldValue: entryData
		)
		let insertEntryComp = getComponent(
			opType: .insert,
			fieldString: insertFieldString,
			newValue: entryData
		)
		return [deleteEntryComp, insertEntryComp]
	}

}
