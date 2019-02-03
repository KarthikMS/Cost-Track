//
//  GroupTableViewControllerTests.swift
//  Cost TrackTests
//
//  Created by Karthik M S on 03/02/19.
//  Copyright © 2019 Karthik M S. All rights reserved.
//

@testable import Cost_Track
import XCTest

class GroupTableViewControllerTests: XCTestCase {

	var documentHandler: DocumentHandler!

	override func setUp() {
		do {
			let document = try Document(jsonString: documentJSON)
			documentHandler = DocumentHandler(document: document)
		} catch {
			assertionFailure("Error converting json to document.")
		}
	}

	func testCreateGroup() {
		let oldGroups = documentHandler.getDocument().groups
		let newGroupName = "New group name"

		documentHandler.insertGroupWithName(newGroupName)

		let newGroups = documentHandler.getDocument().groups
		XCTAssert(newGroups.count == oldGroups.count + 1, "New group not created.")
		XCTAssert(newGroups.last!.name == newGroupName, "New group name not set.")
	}

	func testDeleteGroup() {
		let oldGroups = documentHandler.getDocument().groups
		let deleteIndex = 1
		let groupToDelete = oldGroups[deleteIndex]

		documentHandler.deleteGroupAndMoveRelatedCostSheetsToDefaultGroup(index: deleteIndex)

		let newDocument = documentHandler.getDocument()
		let newGroups = newDocument.groups
		XCTAssert(newGroups.count == oldGroups.count - 1, "Group not deleted.")
		XCTAssert(!newGroups.map { $0.name }.contains(groupToDelete.name), "Delete group name still exists.")
		XCTAssert(!newGroups.map { $0.id }.contains(groupToDelete.id), "Delete group id still exists.")

		let costSheetsInDeletedGroup = newDocument.costSheetsInGroupWithId(groupToDelete.id)
		XCTAssert(costSheetsInDeletedGroup.isEmpty, "Related cost sheets not moved to default group.")
	}

	func testRenameGroup() {
		let updateIndex = 1
		let groupToRename = documentHandler.getDocument().groups[updateIndex]
		let newGroupName = groupToRename.name + "modified"

		documentHandler.renameGroupAt(updateIndex, to: newGroupName)

		let renamedGroup = documentHandler.getDocument().groups[updateIndex]
		XCTAssert(renamedGroup.name == newGroupName, "Group name not updated.")
		XCTAssert(renamedGroup.id == groupToRename.id, "GroupId has changed.")
	}

	// TODO: Finish this.
	func testReorderGroup() {

	}

}
