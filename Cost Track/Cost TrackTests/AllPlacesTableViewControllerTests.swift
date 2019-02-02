//
//  AllPlacesTableViewControllerTests.swift
//  Cost TrackTests
//
//  Created by Karthik M S on 02/02/19.
//  Copyright © 2019 Karthik M S. All rights reserved.
//

@testable import Cost_Track
import XCTest

class AllPlacesTableViewControllerTests: XCTestCase {

	// TODO: Get loaded document from json
	var document = Document()
	var documentHandler: DocumentHandler!

    override func setUp() {
		documentHandler = DocumentHandler(document: document)
    }

	func testAddPlace() {
		let oldPlaces = documentHandler.getDocument().places
		let placeName = "Star Briyani"
		let placeAddress = "Guduvanchery"

		documentHandler.insertPlace(name: placeName, address: placeAddress)

		let newPlaces = documentHandler.getDocument().places
		XCTAssert(newPlaces.count == oldPlaces.count + 1, "New place not added.")
		XCTAssert(newPlaces[newPlaces.count - 1].name == placeName, "New place name not found.")
		XCTAssert(newPlaces[newPlaces.count - 1].address == placeAddress, "New place address not found.")
	}

	func testDeletePlace() {
		documentHandler.insertPlace(name: "placeName", address: "placeAdd")
		let deleteindex = 0
		let oldPlaces = documentHandler.getDocument().places
		let placeToDelete = oldPlaces[deleteindex]
		let relatedEntries = documentHandler.getDocument().entriesWithPlaceId(placeToDelete.id)

		documentHandler.deletePlaceAndClearRelatedPlaceIds(index: deleteindex)

		// Asserting place count
		let newPlaces = documentHandler.getDocument().places
		if oldPlaces.isEmpty {
			XCTAssert(newPlaces.isEmpty, "Place count not correct.")
		} else {
			XCTAssert(newPlaces.count == oldPlaces.count - 1, "Place count not correct.")
		}

		// Asserting placeId == nil in related entries
		for entry in relatedEntries {
			XCTAssert(!entry.hasPlaceID, "Related entries still have the deleted placeId.")
		}
	}

	func testUpdatePlace() {
		documentHandler.insertPlace(name: "placeName", address: "placeAdd")
		let updateindex = 0
		let oldPlaces = documentHandler.getDocument().places
		let placeToUpdate = oldPlaces[updateindex]

		// updatedPlace
		let newName = placeToUpdate.name + "modified"
		let newAddress = placeToUpdate.address + "modified"
		var updatedPlace =  placeToUpdate
		updatedPlace.name = newName
		updatedPlace.address = newAddress

		documentHandler.updatePlace(at: updateindex, with: updatedPlace)

		// Asserting updated details
		let newPlaces = documentHandler.getDocument().places
		XCTAssert(newPlaces[updateindex].name == newName, "Name not updated.")
		XCTAssert(newPlaces[updateindex].address == newAddress, "Address not updated.")
		XCTAssert(newPlaces[updateindex].id == placeToUpdate.id, "Id has changed.")
	}

}
