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
			assert(oldValue == nil, "Insert component should not have oldValue")
			guard let newValue = newValue else {
				assertionFailure("Insert component should have newValue")
				return comp
			}
			comp.value.inBytes.value = newValue
		case .delete:
			assert(newValue == nil, "Delete component should not have newValue")
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

	static func getComponentToInsertGroup(_ group: CostSheetGroup, in document: Document, at index: Int? = nil) -> DocumentContentOperation.Component {
		var insertIndex: Int
		if let index = index {
			insertIndex = index
		} else {
			insertIndex = document.groups.count
		}
		let fieldString = "2,arr:\(insertIndex)"
		return getComponent(opType: .insert, fieldString: fieldString, newValue: group.safeSerializedData)
	}

	static func getComponentToDeleteGroup(at index: Int, in document: Document) -> DocumentContentOperation.Component {
		let group = document.groups[index]
		let fieldString = "2,arr:\(index)"
		return getComponent(opType: .delete, fieldString: fieldString, oldValue: group.safeSerializedData)
	}

	static func getComponentToInsertCostSheet(_ costSheet: CostSheet, in document: Document, at index: Int? = nil) -> DocumentContentOperation.Component {
		var insertIndex: Int
		if let index = index {
			insertIndex = index
		} else {
			insertIndex = document.costSheets.count
		}
		let fieldString = "1,arr:\(insertIndex)"
		return getComponent(opType: .insert, fieldString: fieldString, newValue: costSheet.safeSerializedData)
	}

	static func getComponentToDeleteCostSheet(at index: Int, in document: Document) -> DocumentContentOperation.Component {
		let costSheet = document.costSheets[index]
		let fieldString = "1,arr:\(index)"
		return getComponent(opType: .delete, fieldString: fieldString, oldValue: costSheet.safeSerializedData)
	}

	static func getComponentToDeleteCostSheet(withId costSheetId: String, in document: Document) -> DocumentContentOperation.Component {
		guard let index = document.indexOfCostSheetWithId(costSheetId) else {
			assertionFailure()
			return DocumentContentOperation.Component()
		}
		return getComponentToDeleteCostSheet(at: index, in: document)
	}

	static func getComponentToUpdateGroupOfCostSheet(at index: Int, from fromGroup: CostSheetGroup, to toGroup: CostSheetGroup, in document: Document) -> DocumentContentOperation.Component {
		let fieldString = "1,arr:\(index),4"
		return getComponent(
			opType: .update,
			fieldString: fieldString,
			oldValue: fromGroup.safeSerializedData,
			newValue: toGroup.safeSerializedData
		)
	}

	static func getComponentsToMoveCostSheets(from fromGroup: CostSheetGroup, to toGroup: CostSheetGroup, in document: Document) -> [DocumentContentOperation.Component] {
		var comps = [DocumentContentOperation.Component]()
		for i in 0..<document.costSheets.count where document.costSheets[i].group.id == fromGroup.id {
			let updateGroupComp = getComponentToUpdateGroupOfCostSheet(at: i, from: fromGroup, to: toGroup, in: document)
			comps.append(updateGroupComp)
		}
		return comps
	}

	static func getComponentToUpdateEntryWithId(_ entryId: String, with updatedEntry: CostSheetEntry, inCostSheetWithId costSheetId: String, document: Document) -> DocumentContentOperation.Component {
		guard let costSheetIndex = document.indexOfCostSheetWithId(costSheetId) else {
			assertionFailure("Could not get costSheetIndex")
			return DocumentContentOperation.Component()
		}
		let costSheet = document.costSheets[costSheetIndex]
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

	static func getComponentToInsertEntry(_ newEntry: CostSheetEntry, inCostSheetWithId costSheetId: String, document: Document, at index: Int? = nil) -> DocumentContentOperation.Component {
		guard let costSheetIndex = document.indexOfCostSheetWithId(costSheetId) else {
			assertionFailure("Could not get costSheetIndex")
			return DocumentContentOperation.Component()
		}
		let costSheet = document.costSheets[costSheetIndex]
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

	static func getComponentToDeleteEntryWithId(_ entryId: String, inCostSheetWithId costSheetId: String, document: Document) -> DocumentContentOperation.Component {
		guard let costSheetIndex = document.indexOfCostSheetWithId(costSheetId) else {
			assertionFailure("Could not get costSheetIndex")
			return DocumentContentOperation.Component()
		}
		let costSheet = document.costSheets[costSheetIndex]
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

	static func getComponentsToTransferEntry(withId entryId: String, fromCostSheetWithId fromCostSheetId: String, toCostSheetWithId toCostSheetId: String, document: Document) -> [DocumentContentOperation.Component] {
		guard let fromCostSheetIndex = document.indexOfCostSheetWithId(fromCostSheetId),
		let toCostSheetIndex = document.indexOfCostSheetWithId(toCostSheetId) else {
			assertionFailure("Could not get costSheetIndex")
			return []
		}
		let fromCostSheet = document.costSheets[fromCostSheetIndex]
		let toCostSheet = document.costSheets[toCostSheetIndex]
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
