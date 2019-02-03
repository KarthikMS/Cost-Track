//
//  DocumentHandler.swift
//  Cost Track
//
//  Created by Karthik M S on 02/02/19.
//  Copyright © 2019 Karthik M S. All rights reserved.
//

import Foundation

class DocumentHandler {

	private var document: Document

	init(document: Document) {
		self.document = document
	}

}

extension DocumentHandler: DocumentModel {

	// MARK: Place
	func getDocument() -> Document {
		return document
	}

	func deleteDocument() {
		if ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] == nil {
			// Code only executes when tests are running
			CTFileManager.deleteDocument()
		}

		(document, _) = CTFileManager.getDocument()

		if ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] == nil {
			// Code only executes when tests are running
			CTFileManager.saveDocument(document)
		}
	}

	func insertPlace(name: String, address: String) {
		var newPlace = Place()
		newPlace.name = name
		newPlace.address = address
		newPlace.id = UUID().uuidString

		// Delta Component
		let insertPlaceComponent = DeltaUtil.getComponentToInsertPlace(newPlace, in: document)
		sendDeltaComponents([insertPlaceComponent])
	}

	func deletePlaceAndClearRelatedPlaceIds(index: Int) {
		let deletePlaceComp = DeltaUtil.getComponentToDeletePlace(at: index, in: document)

		let placeToDelete = document.places[index]
		let clearPlaceIdComps = DeltaUtil.getComponentToClearPlaceIdsForEntries(withPlaceId: placeToDelete.id, in: document)

		let deltaComps = [deletePlaceComp] + clearPlaceIdComps
		sendDeltaComponents(deltaComps)
	}

	func updatePlace(at index: Int, with updatedPlace: Place) {
		let updatePlaceComponent = DeltaUtil.getComponentToUpdatePlace(updatedPlace, in: document, at: index)
		sendDeltaComponents([updatePlaceComponent])
	}

	// MARK: Group
	func insertGroupWithName(_ name: String) {
		var newGroup = CostSheetGroup()
		newGroup.name = name
		newGroup.id = UUID().uuidString

		let insertGroupComponent = DeltaUtil.getComponentToInsertGroup(newGroup, in: document)
		sendDeltaComponents([insertGroupComponent])
	}

	func deleteGroupAndMoveRelatedCostSheetsToDefaultGroup(index: Int) {
		let deleteGroupComp = DeltaUtil.getComponentToDeleteGroup(at: index, in: document)
		let moveCostSheetsComps = DeltaUtil.getComponentsToMoveCostSheets(from: document.groups[index], to: NotSetGroup, in: document)
		let deltaComps = [deleteGroupComp] + moveCostSheetsComps
		sendDeltaComponents(deltaComps)
	}

}

// MARK: DeltaDelegate
extension DocumentHandler: DeltaDelegate {

	func sendDeltaComponents(_ components: [DocumentContentOperation.Component]) {
		for component in components {
			do {
				var decoder = try DeltaDataApplier(fieldString: component.fields, value: component.value.inBytes.value, operationType: component.opType)
				try document.decodeMessage(decoder: &decoder)
			} catch {
				assertionFailure(error.localizedDescription)
			}
		}
		if ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] == nil {
			// Code only executes when tests are running
			CTFileManager.saveDocument(document)
		}
	}

}
