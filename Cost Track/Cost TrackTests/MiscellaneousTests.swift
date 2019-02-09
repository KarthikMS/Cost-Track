//
//  MiscellaneousTests.swift
//  Cost TrackTests
//
//  Created by Karthik M S on 09/02/19.
//  Copyright © 2019 Karthik M S. All rights reserved.
//

@testable import Cost_Track
import XCTest

class MiscellaneousTests: XCTestCase {

	var documentHandler: DocumentHandler!

	override func setUp() {
		do {
			let document = try Document(jsonString: documentJSON)
			documentHandler = DocumentHandler(document: document)
		} catch {
			assertionFailure("Error converting json to document.")
		}
	}

	func testTransferEntry() {
		let fromCostSheetIndex = 0
		let toCostSheetIndex = 2
		let fromCostSheetBeforeTransfer = documentHandler.getDocument().costSheets[fromCostSheetIndex]
		let toCostSheetBeforeTransfer = documentHandler.getDocument().costSheets[toCostSheetIndex]
		let entryToTransfer = fromCostSheetBeforeTransfer.entries[0]

		documentHandler.transferEntry(withId: entryToTransfer.id, fromCostSheetWithId: fromCostSheetBeforeTransfer.id, toCostSheetWithId: toCostSheetBeforeTransfer.id)

		let fromCostSheetAfterTransfer = documentHandler.getDocument().costSheets[fromCostSheetIndex]
		let toCostSheetAfterTransfer = documentHandler.getDocument().costSheets[toCostSheetIndex]

		XCTAssert(fromCostSheetAfterTransfer.entries.count == fromCostSheetBeforeTransfer.entries.count - 1, "Entry not deleted from fromCostSheet.")
		XCTAssert(!fromCostSheetAfterTransfer.entries.map { $0.id }.contains(entryToTransfer.id), "Entry not deleted from fromCostSheet.")
		XCTAssert(toCostSheetAfterTransfer.entries.count == toCostSheetBeforeTransfer.entries.count + 1, "Entry not added to toCostSheet.")
		XCTAssert(toCostSheetAfterTransfer.entries.map { $0.id }.contains(entryToTransfer.id), "Entry not added to toCostSheet.")
	}

}
