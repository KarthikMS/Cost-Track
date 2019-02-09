//
//  NewCostSheetViewControllerTests.swift
//  Cost TrackTests
//
//  Created by Karthik M S on 09/02/19.
//  Copyright © 2019 Karthik M S. All rights reserved.
//

@testable import Cost_Track
import XCTest

class NewCostSheetViewControllerTests: XCTestCase {

	var documentHandler: DocumentHandler!

	override func setUp() {
		documentHandler = DocumentHandler(document: testDocument)
	}

	func testAddCostSheet() {
		let oldDocument = documentHandler.getDocument()
		var newCostSheet = CostSheet()
		newCostSheet.id = UUID().uuidString
		newCostSheet.createdOnDate = Date().data
		newCostSheet.lastModifiedDate = newCostSheet.createdOnDate
		newCostSheet.initialBalance = 10
		newCostSheet.includeInOverallTotal = true
		newCostSheet.name = "New Cost Sheet"
		let groupId = oldDocument.groups[0].id
		newCostSheet.groupID = groupId

		documentHandler.addCostSheet(newCostSheet)

		let newDocument = documentHandler.getDocument()
		XCTAssert(newDocument.costSheets.count == oldDocument.costSheets.count + 1, "Cost sheet not added.")
		XCTAssert(newDocument.costSheets.last!.id == newCostSheet.id, "New cost sheet id not found.")
		XCTAssert(newDocument.costSheetsInGroupWithId(groupId).count == oldDocument.costSheetsInGroupWithId(groupId).count + 1, "New cost sheet not added to group.")
		XCTAssert(newDocument.costSheetsInGroupWithId(groupId).map { $0.id }.contains(newCostSheet.id), "New cost sheet not added to group.")
	}

}
