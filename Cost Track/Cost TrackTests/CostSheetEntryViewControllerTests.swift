//
//  CostSheetEntryViewControllerTests.swift
//  Cost TrackTests
//
//  Created by Karthik M S on 10/02/19.
//  Copyright © 2019 Karthik M S. All rights reserved.
//

@testable import Cost_Track
import XCTest

class CostSheetEntryViewControllerTests: XCTestCase {

	var documentHandler: DocumentHandler!

	override func setUp() {
		documentHandler = DocumentHandler(document: testDocument)
	}

	func testAddCostSheetEntry() {
		let oldDocument = documentHandler.getDocument()
		let oldCostSheet = oldDocument.costSheets[0]
		var newEntry = CostSheetEntry()
		newEntry.type = .expense
		newEntry.amount = 100
		newEntry.categoryID = oldDocument.categoriesFilteredByEntryType(.expense)[0].id
		newEntry.placeID = oldDocument.places[0].id
		newEntry.date = Date().data
		newEntry.description_p = "Some description."
		newEntry.id = UUID().uuidString

		documentHandler.insertCostSheetEntry(newEntry, inCostSheetWithId: oldCostSheet.id)

		let newCostSheet = documentHandler.getDocument().costSheets[0]
		let addedEntry = newCostSheet.entries.last!
		XCTAssert(newCostSheet.entries.count == oldCostSheet.entries.count + 1, "Entry not added.")
		XCTAssert(addedEntry.type == newEntry.type, "Entry type not correct.")
		XCTAssert(addedEntry.amount == newEntry.amount, "Amount not correct.")
		XCTAssert(addedEntry.categoryID == newEntry.categoryID, "Category not correct.")
		XCTAssert(addedEntry.placeID == newEntry.placeID, "PlaceId not correct.")
		XCTAssert(addedEntry.date == newEntry.date, "Date not correct.")
		XCTAssert(addedEntry.description_p == newEntry.description_p, "Description not correct.")
		XCTAssert(addedEntry.id == newEntry.id, "Id not correct.")
	}

	func testAddTransferCostSheetEntry() {

	}

	func testDeleteCostSheetEntry() {
		let oldCostSheet = documentHandler.getDocument().costSheets[0]
		let entryToDelete = oldCostSheet.entries[0]

		documentHandler.deleteCostSheetEntry(withId: entryToDelete.id, inCostSheetWithId: oldCostSheet.id)

		let newCostSheet = documentHandler.getDocument().costSheets[0]
		XCTAssert(newCostSheet.entries.count == oldCostSheet.entries.count - 1, "Entry not deleted.")
		XCTAssert(!newCostSheet.entries.map { $0.id }.contains(entryToDelete.id), "Deleted entry id still found.")
	}

	func testDeleteTransferCostSheetEntry() {

	}

	func testUpdateCostSheetEntry() {
		let oldDocument = documentHandler.getDocument()
		let oldCostSheet = oldDocument.costSheets[0]
		let entryBeforeUpdate = oldCostSheet.entries[0]
		var updatedEntry = entryBeforeUpdate
		updatedEntry.type = updatedEntry.type == .income ? .expense : .income
		updatedEntry.amount += 100
		updatedEntry.categoryID = oldDocument.categoriesFilteredByEntryType(.expense)[4].id
		updatedEntry.placeID = oldDocument.places[1].id
		updatedEntry.date = Date().data
		updatedEntry.description_p += "modified"

		documentHandler.updateCostSheetEntry(updatedEntry, inCostSheetWithId: oldCostSheet.id)

		let newCostSheet = documentHandler.getDocument().costSheets[0]
		let entryAfterUpdate = newCostSheet.entries[0]
		XCTAssert(newCostSheet.entries.count == oldCostSheet.entries.count
			, "Entry count is not the same.")
		XCTAssert(entryAfterUpdate.type == updatedEntry.type, "EntryType not updated.")
		XCTAssert(entryAfterUpdate.amount == updatedEntry.amount, "Amount not updated.")
		XCTAssert(entryAfterUpdate.categoryID == updatedEntry.categoryID, "Category not updated.")
		XCTAssert(entryAfterUpdate.placeID == updatedEntry.placeID, "PlaceId not updated.")
		XCTAssert(entryAfterUpdate.date == updatedEntry.date, "Date not updated.")
		XCTAssert(entryAfterUpdate.description_p == updatedEntry.description_p, "Description not updated.")
		XCTAssert(entryAfterUpdate.id == updatedEntry.id, "Id changed.")
	}

	func testUpdateTransferCostSheetEntry() {

	}

}
