//
//  DocumentModel.swift
//  Cost Track
//
//  Created by Karthik M S on 02/02/19.
//  Copyright © 2019 Karthik M S. All rights reserved.
//

protocol DocumentModelSource {
	func getDocument() -> Document
	func deleteDocument()
}

protocol DocumentModelInput {
	// Place
	func insertPlace(name: String, address: String)
	func deletePlaceAndClearRelatedPlaceIds(index: Int)
	func updatePlace(at index: Int, with newPlace: Place)

	// Group
	func insertGroupWithName(_ name: String)
	func deleteGroupAndMoveRelatedCostSheetsToDefaultGroup(index: Int)
	func renameGroupAt(_ index: Int, to newName: String)
	func reorderGroup(from fromIndex: Int, to toIndex: Int)

	// Entry
	/// waitForFurtherCommands delays sending of delta and gathers all delta components. Default value should be false. Make sure to call these functions with waitForFurtherCommands as false atleast once after you've called these functions with waitForFurtherCommands as true
	func insertCostSheetEntry(_ newEntry: CostSheetEntry, inCostSheetWithId costSheetId: String, waitForFurtherCommands: Bool)
	func deleteCostSheetEntry(withId entryId: String, inCostSheetWithId costSheetId: String, waitForFurtherCommands: Bool)
	func updateCostSheetEntry(_ updatedEntry: CostSheetEntry, inCostSheetWithId costSheetId: String, waitForFurtherCommands: Bool)
	func transferEntry(withId entryId: String, fromCostSheetWithId fromCostSheetId: String, toCostSheetWithId toCostSheetId: String, waitForFurtherCommands: Bool)

	// CostSheet
	func addCostSheet(_ costSheet: CostSheet)
	func deleteCostSheet(withId costSheetId: String)
	func updateCostSheet(_ updatedCostSheet: CostSheet)
}

protocol DocumentModel: DocumentModelSource, DocumentModelInput {

}
