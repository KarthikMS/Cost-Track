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

	static func getComponentToReorderGroup(from fromIndex: Int, to toIndex: Int, in document: Document) -> [DocumentContentOperation.Component] {
		let group = document.groups[fromIndex]
		let deleteComp = getComponent(
			opType: .delete,
			fieldString: "2,arr:\(fromIndex)",
			oldValue: group.safeSerializedData
		)
		let insertComp = getComponent(
			opType: .insert,
			fieldString: "2,arr:\(toIndex)",
			newValue: group.safeSerializedData
		)
		return [deleteComp, insertComp]
	}

	static func getComponentToRenameGroup(at index: Int, to newName: String, in document: Document) -> DocumentContentOperation.Component {
		let oldName = document.groups[index].name
		return getComponent(
			opType: .update,
			fieldString: "2,arr:\(index),1",
			oldValue: oldName.data(using: String.Encoding.utf8),
			newValue: newName.data(using: String.Encoding.utf8)
		)
	}

	static func getComponentToInsertPlace(_ place: Place, in document: Document, at index: Int? = nil) -> DocumentContentOperation.Component {
		var insertIndex: Int
		if let index = index {
			insertIndex = index
		} else {
			insertIndex = document.places.count
		}
		let fieldString = "4,arr:\(insertIndex)"
		return getComponent(opType: .insert, fieldString: fieldString, newValue: place.safeSerializedData)
	}

	static func getComponentToDeletePlace(at index: Int, in document: Document) -> DocumentContentOperation.Component {
		let oldPlace = document.places[index]
		let fieldString = "4,arr:\(index)"
		return getComponent(opType: .delete, fieldString: fieldString, oldValue: oldPlace.safeSerializedData)
	}

	static func getComponentToUpdatePlace(_ updatedPlace: Place, in document: Document, at index: Int) -> DocumentContentOperation.Component {
		let fieldString = "4,arr:\(index)"
		let oldPlace = document.places[index]
		return getComponent(
			opType: .update,
			fieldString: fieldString,
			oldValue: oldPlace.safeSerializedData,
			newValue: updatedPlace.safeSerializedData
		)
	}

	static func getComponentToClearPlaceIdsForEntries(withPlaceId placeId: String, in document: Document) -> [DocumentContentOperation.Component] {
		var comps = [DocumentContentOperation.Component]()

		for i in 0..<document.costSheets.count {
			let costSheet = document.costSheets[i]
			for j in 0..<costSheet.entries.count {
				let entry = costSheet.entries[j]
				guard let entryPlace = document.getPlace(withId: entry.placeID) else {
					assertionFailure("Could not get place by Id")
					return []
				}
				if entryPlace.id == placeId {
					var newEntry = entry
					newEntry.clearPlaceID()

					let fieldString = "1,arr:\(i),5,arr:\(j),5"

					let comp = getComponent(
						opType: .update,
						fieldString: fieldString,
						oldValue: entry.safeSerializedData,
						newValue: newEntry.safeSerializedData
					)
					comps.append(comp)
				}
			}
		}

		return comps
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

	static func getComponentToUpdateCostSheet(withId costSheetId: String, with updatedCostSheet: CostSheet, in document: Document) -> DocumentContentOperation.Component {
		guard let index = document.indexOfCostSheetWithId(costSheetId) else {
			assertionFailure()
			return DocumentContentOperation.Component()
		}
		let oldCostSheet = document.costSheets[index]
		let fieldString = "1,arr:\(index)"
		let comp = getComponent(
			opType: .update,
			fieldString: fieldString,
			oldValue: oldCostSheet.safeSerializedData,
			newValue: updatedCostSheet.safeSerializedData
		)
		return comp
	}

	// TODO: Fix this
	static func getComponentsToUpdatePropertiesOfCostSheet(withId costSheetId: String, in document: Document, name: String?, initialBalance: Float?, includeInOverallTotal: Bool?, groupId: String?, lastModifiedData: Data) -> [DocumentContentOperation.Component] {
		guard let index = document.indexOfCostSheetWithId(costSheetId) else {
			assertionFailure()
			return []
		}
		let oldCostSheet = document.costSheets[index]
		let costSheetFieldString = "1,arr:\(index)"
		var deltaComps = [DocumentContentOperation.Component]()
		if let name = name {
			let updateNameComp = getComponent(
				opType: .update,
				fieldString: costSheetFieldString + ",1",
				oldValue: oldCostSheet.name.data(using: String.Encoding.utf8),
				newValue: name.data(using: String.Encoding.utf8)
			)
			deltaComps.append(updateNameComp)
		}
		if let initialBalance = initialBalance {
			let updateInitialBalanceComp = getComponent(
				opType: .update,
				fieldString: costSheetFieldString + ",2",
				oldValue: oldCostSheet.initialBalance.data,
				newValue: initialBalance.data
			)
			deltaComps.append(updateInitialBalanceComp)
		}
		if let includeInOverallTotal = includeInOverallTotal {
			let updateIncludeInOverallTotal = getComponent(
				opType: .update,
				fieldString: costSheetFieldString + ",3",
				oldValue: oldCostSheet.includeInOverallTotal.data,
				newValue: includeInOverallTotal.data
			)
			deltaComps.append(updateIncludeInOverallTotal)
		}
		if let groupId = groupId {
			let updateIncludeInOverallTotal = getComponent(
				opType: .update,
				fieldString: costSheetFieldString + ",4",
				oldValue: oldCostSheet.groupID.data(using: String.Encoding.utf8),
				newValue: groupId.data(using: String.Encoding.utf8)
			)
			deltaComps.append(updateIncludeInOverallTotal)
		}
		let updateLastModifiedDateComp = getComponent(
			opType: .update,
			fieldString: costSheetFieldString + ",6",
			oldValue: oldCostSheet.lastModifiedDate,
			newValue: lastModifiedData
		)
		deltaComps.append(updateLastModifiedDateComp)
		return deltaComps
	}

	static func getComponentToUpdateGroupIdOfCostSheet(at index: Int, from fromId: String, to toId: String, in document: Document) -> DocumentContentOperation.Component {
		let fieldString = "1,arr:\(index),4"
		return getComponent(
			opType: .update,
			fieldString: fieldString,
			oldValue: fromId.data(using: String.Encoding.utf8),
			newValue: toId.data(using: String.Encoding.utf8)
		)
	}

	static func getComponentsToMoveCostSheets(fromGroupWithId fromGroupId: String, toGroupWithId toGroupId: String, in document: Document) -> [DocumentContentOperation.Component] {
		var comps = [DocumentContentOperation.Component]()
		for (i, costSheet) in document.costSheets.enumerated() where costSheet.groupID == fromGroupId {
			let updateGroupComp = getComponentToUpdateGroupIdOfCostSheet(at: i, from: fromGroupId, to: toGroupId, in: document)
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

	static func getComponentToDeleteEntry(withId entryId: String, inCostSheetWithId costSheetId: String, document: Document) -> DocumentContentOperation.Component {
		guard let costSheetIndex = document.indexOfCostSheetWithId(costSheetId) else {
			assertionFailure("Could not get cost sheet with Id: \(costSheetId)")
			return DocumentContentOperation.Component()
		}
		let costSheet = document.costSheets[costSheetIndex]
		guard let entryIndex = costSheet.indexOfEntryWithId(entryId) else {
			assertionFailure("Could not get entry with Id: \(entryId)")
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

	static func getComponentsToTransferEntry(withId entryId: String, fromCostSheetWithId fromCostSheetId: String, toCostSheetWithId toCostSheetId: String, in document: Document) -> [DocumentContentOperation.Component] {
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
