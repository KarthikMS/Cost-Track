//
//  DocumentTests.swift
//  Cost TrackTests
//
//  Created by Karthik M S on 03/02/19.
//  Copyright © 2019 Karthik M S. All rights reserved.
//

@testable import Cost_Track
import XCTest

class DocumentTests: XCTestCase {

	var documentHandler: DocumentHandler!

	override func setUp() {
		documentHandler = DocumentHandler(document: testDocument)
	}

	func testDeleteDocument() {
		guard let oldDocumentCreatedOnDate = documentHandler.getDocument().createdOnDate.date else {
			assertionFailure("Could not get createOnDate.")
			return
		}

		documentHandler.deleteDocument()

		let newDocument = documentHandler.getDocument()
		guard let newDocumentCreatedOnDate = newDocument.createdOnDate.date else {
			assertionFailure("Could not get createOnDate.")
			return
		}
		XCTAssert(newDocumentCreatedOnDate != oldDocumentCreatedOnDate, "New document has same createdOnDate.")
		XCTAssert(newDocument.costSheets.isEmpty, "New document has cost sheets.")
		XCTAssert(newDocument.groups.count == 1, "New document has groups.")
		XCTAssert(newDocument.categories == Category.defaultCategories(), "New document does not have default categories.")
		XCTAssert(newDocument.places.isEmpty, "New document has places.")
	}

}
