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

	func insertPlaceWithName(_ name: String) {
		var newPlace = Place()
		newPlace.name = name
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
