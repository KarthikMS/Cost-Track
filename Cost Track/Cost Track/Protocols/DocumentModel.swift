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

	func transferEntry(withId entryId: String, fromCostSheetWithId fromCostSheetId: String, toCostSheetWithId toCostSheetId: String)
	func deleteEntry(withId entryId: String, inCostSheetWithId costSheetId: String)

	func deleteCostSheet(withId costSheetId: String)
}

protocol DocumentModel: DocumentModelSource, DocumentModelInput {

}
