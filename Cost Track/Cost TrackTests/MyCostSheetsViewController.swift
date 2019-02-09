//
//  MyCostSheetsViewController.swift
//  Cost TrackTests
//
//  Created by Karthik M S on 09/02/19.
//  Copyright © 2019 Karthik M S. All rights reserved.
//

@testable import Cost_Track
import XCTest

class MyCostSheetsViewController: XCTestCase {

	var documentHandler: DocumentHandler!

	override func setUp() {
		documentHandler = DocumentHandler(document: testDocument)
	}

	func testDeleteCostSheet() {
		let documentBeforeDelete = documentHandler.getDocument()
		let costSheetToDelete = documentBeforeDelete.costSheets[0]

		documentHandler.deleteCostSheet(withId: costSheetToDelete.id)

		let newDocument = documentHandler.getDocument()
		XCTAssert(newDocument.costSheets.count == documentBeforeDelete.costSheets.count - 1, "CostSheet not deleted.")
		XCTAssert(!newDocument.costSheets.map { $0.id }.contains(costSheetToDelete.id), "CostSheet not deleted.")
	}

}
