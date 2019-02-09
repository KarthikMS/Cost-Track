//
//  CostSheetSettingsViewControllerTests.swift
//  Cost TrackTests
//
//  Created by Karthik M S on 09/02/19.
//  Copyright © 2019 Karthik M S. All rights reserved.
//

@testable import Cost_Track
import XCTest

class CostSheetSettingsViewControllerTests: XCTestCase {

	var documentHandler: DocumentHandler!

	override func setUp() {
		documentHandler = DocumentHandler(document: testDocument)
	}

	func testUpdateCostSheet() {
		let oldDocument = documentHandler.getDocument()
		let oldCostSheet = oldDocument.costSheets[0]
		var costSheetWithUpdatedValues = oldCostSheet
		costSheetWithUpdatedValues.name += "modified"
		costSheetWithUpdatedValues.initialBalance += 1000
		costSheetWithUpdatedValues.includeInOverallTotal = !costSheetWithUpdatedValues.includeInOverallTotal
		costSheetWithUpdatedValues.groupID = documentHandler.getDocument().groups[2].id

		documentHandler.updateCostSheet(costSheetWithUpdatedValues)

		let newDocument = documentHandler.getDocument()
		let updatedCostSheet = newDocument.costSheets[0]
		XCTAssert(updatedCostSheet.id == oldCostSheet.id, "Id changed.")
		XCTAssert(updatedCostSheet.name == oldCostSheet.name + "modified", "Name not updated.")
		XCTAssert(updatedCostSheet.initialBalance == oldCostSheet.initialBalance + 1000, "Initial balance not updated.")
		XCTAssert(updatedCostSheet.includeInOverallTotal == !oldCostSheet.includeInOverallTotal, "includeInOverallTotal not updated.")
		XCTAssert(updatedCostSheet.groupID == documentHandler.getDocument().groups[2].id, "GroupId not updated.")
		XCTAssert(updatedCostSheet.lastModifiedDate != oldCostSheet.lastModifiedDate, "lastModifiedDate not updated.")
		XCTAssert(updatedCostSheet.createdOnDate == oldCostSheet.createdOnDate, "createdOnDate changed.")
		XCTAssert(updatedCostSheet.entries == oldCostSheet.entries, "Entries changed.")

		XCTAssert(newDocument.numberOfCostSheetsInGroupWithId(oldCostSheet.groupID) == oldDocument.numberOfCostSheetsInGroupWithId(oldCostSheet.groupID) - 1, "Cost sheet not removed from old group.")
		XCTAssert(newDocument.numberOfCostSheetsInGroupWithId(costSheetWithUpdatedValues.groupID) == oldDocument.numberOfCostSheetsInGroupWithId(costSheetWithUpdatedValues.groupID) + 1, "Cost sheet not added to bew group.")
	}

}
