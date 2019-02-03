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
		// Uncomment and use the next block of code to use json document
		self.document = document

		// JSON
//		do {
//			self.document = try Document(jsonString: documentJSON)
//		} catch {
//			self.document = document
//		}
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

	func renameGroupAt(_ index: Int, to newName: String) {
		let groupToRename = getDocument().groups[index]
		// TODO: Finish this.
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

var documentJSON = "{\"costSheets\":[{\"name\":\"Purse\",\"initialBalance\":2000,\"includeInOverallTotal\":true,\"group\":{\"name\":\"Not set\",\"id\":\"FA62D2C4-2DB3-44FD-9E66-CE0440094133\"},\"entries\":[{\"type\":\"EXPENSE\",\"amount\":120,\"category\":{\"name\":\"Food & Drinks\",\"iconType\":\"FOOD_AND_DRINKS\",\"entryTypes\":[\"EXPENSE\"]},\"placeId\":\"EA04F4B6-9129-430C-89BE-0C1CC902E21F\",\"date\":\"YnBsaXN0MDDUAQIDBAUGExRYJHZlcnNpb25YJG9iamVjdHNZJGFyY2hpdmVyVCR0b3ASAAGGoKMHCA1VJG51bGzSCQoLDFdOUy50aW1lViRjbGFzcyNBwQD7h4AAAIAC0g4PEBFaJGNsYXNzbmFtZVgkY2xhc3Nlc1ZOU0RhdGWiEBJYTlNPYmplY3RfEA9OU0tleWVkQXJjaGl2ZXLRFRZUcm9vdIABCBEaIy0yNztBRk5VXmBlcHmAg4yeoaYAAAAAAAABAQAAAAAAAAAXAAAAAAAAAAAAAAAAAAAAqA==\",\"description\":\"Samosa\",\"id\":\"81D93CD2-272C-40C9-8883-D515AA3DEDB4\"},{\"type\":\"EXPENSE\",\"amount\":460,\"category\":{\"name\":\"Food & Drinks\",\"iconType\":\"FOOD_AND_DRINKS\",\"entryTypes\":[\"EXPENSE\"]},\"placeId\":\"FC7E33F2-6A12-40C5-A6F7-748159E8E5C8\",\"date\":\"YnBsaXN0MDDUAQIDBAUGExRYJHZlcnNpb25YJG9iamVjdHNZJGFyY2hpdmVyVCR0b3ASAAGGoKMHCA1VJG51bGzSCQoLDFdOUy50aW1lViRjbGFzcyNBwQRHuwAAAIAC0g4PEBFaJGNsYXNzbmFtZVgkY2xhc3Nlc1ZOU0RhdGWiEBJYTlNPYmplY3RfEA9OU0tleWVkQXJjaGl2ZXLRFRZUcm9vdIABCBEaIy0yNztBRk5VXmBlcHmAg4yeoaYAAAAAAAABAQAAAAAAAAAXAAAAAAAAAAAAAAAAAAAAqA==\",\"description\":\"\",\"id\":\"3049CC46-9EB4-4584-B6E7-34929B9485D4\"}],\"lastModifiedDate\":\"YnBsaXN0MDDUAQIDBAUGExRYJHZlcnNpb25YJG9iamVjdHNZJGFyY2hpdmVyVCR0b3ASAAGGoKMHCA1VJG51bGzSCQoLDFdOUy50aW1lViRjbGFzcyNBwQL1xIdy74AC0g4PEBFaJGNsYXNzbmFtZVgkY2xhc3Nlc1ZOU0RhdGWiEBJYTlNPYmplY3RfEA9OU0tleWVkQXJjaGl2ZXLRFRZUcm9vdIABCBEaIy0yNztBRk5VXmBlcHmAg4yeoaYAAAAAAAABAQAAAAAAAAAXAAAAAAAAAAAAAAAAAAAAqA==\",\"createdOnDate\":\"YnBsaXN0MDDUAQIDBAUGExRYJHZlcnNpb25YJG9iamVjdHNZJGFyY2hpdmVyVCR0b3ASAAGGoKMHCA1VJG51bGzSCQoLDFdOUy50aW1lViRjbGFzcyNBwQL1xIdy74AC0g4PEBFaJGNsYXNzbmFtZVgkY2xhc3Nlc1ZOU0RhdGWiEBJYTlNPYmplY3RfEA9OU0tleWVkQXJjaGl2ZXLRFRZUcm9vdIABCBEaIy0yNztBRk5VXmBlcHmAg4yeoaYAAAAAAAABAQAAAAAAAAAXAAAAAAAAAAAAAAAAAAAAqA==\",\"id\":\"EAA988E3-60F3-4EC7-8516-EA82A11D1F55\"},{\"name\":\"Aditya Birla Sun Life\",\"initialBalance\":12000,\"includeInOverallTotal\":true,\"group\":{\"name\":\"Mutual funds\",\"id\":\"64D6CAFB-81E6-4118-BE31-E179B7BB0F8B\"},\"lastModifiedDate\":\"YnBsaXN0MDDUAQIDBAUGExRYJHZlcnNpb25YJG9iamVjdHNZJGFyY2hpdmVyVCR0b3ASAAGGoKMHCA1VJG51bGzSCQoLDFdOUy50aW1lViRjbGFzcyNBwQNgammyzIAC0g4PEBFaJGNsYXNzbmFtZVgkY2xhc3Nlc1ZOU0RhdGWiEBJYTlNPYmplY3RfEA9OU0tleWVkQXJjaGl2ZXLRFRZUcm9vdIABCBEaIy0yNztBRk5VXmBlcHmAg4yeoaYAAAAAAAABAQAAAAAAAAAXAAAAAAAAAAAAAAAAAAAAqA==\",\"createdOnDate\":\"YnBsaXN0MDDUAQIDBAUGExRYJHZlcnNpb25YJG9iamVjdHNZJGFyY2hpdmVyVCR0b3ASAAGGoKMHCA1VJG51bGzSCQoLDFdOUy50aW1lViRjbGFzcyNBwQNgammyzIAC0g4PEBFaJGNsYXNzbmFtZVgkY2xhc3Nlc1ZOU0RhdGWiEBJYTlNPYmplY3RfEA9OU0tleWVkQXJjaGl2ZXLRFRZUcm9vdIABCBEaIy0yNztBRk5VXmBlcHmAg4yeoaYAAAAAAAABAQAAAAAAAAAXAAAAAAAAAAAAAAAAAAAAqA==\",\"id\":\"20076144-350B-48A2-81FD-165A5EF3A2B8\"}],\"groups\":[{\"name\":\"Not set\",\"id\":\"FA62D2C4-2DB3-44FD-9E66-CE0440094133\"},{\"name\":\"Mutual funds\",\"id\":\"64D6CAFB-81E6-4118-BE31-E179B7BB0F8B\"}],\"categories\":[{\"name\":\"Salary\",\"iconType\":\"SALARY\",\"entryTypes\":[\"INCOME\"]},{\"name\":\"Vehicle & Transport\",\"iconType\":\"VEHICLE_AND_TRANSPORT\",\"entryTypes\":[\"EXPENSE\"]},{\"name\":\"Household\",\"iconType\":\"HOUSEHOLD\",\"entryTypes\":[\"INCOME\",\"EXPENSE\"]},{\"name\":\"Shopping\",\"iconType\":\"SHOPPING\",\"entryTypes\":[\"EXPENSE\"]},{\"name\":\"Phone\",\"iconType\":\"PHONE\",\"entryTypes\":[\"EXPENSE\"]},{\"name\":\"Entertainment\",\"iconType\":\"ENTERTAINMENT\",\"entryTypes\":[\"INCOME\",\"EXPENSE\"]},{\"name\":\"Medicine\",\"iconType\":\"MEDICINE\",\"entryTypes\":[\"EXPENSE\"]},{\"name\":\"Investment\",\"iconType\":\"INVESTMENT\",\"entryTypes\":[\"INCOME\",\"EXPENSE\"]},{\"name\":\"Tax\",\"iconType\":\"TAX\",\"entryTypes\":[\"EXPENSE\"]},{\"name\":\"Insurance\",\"iconType\":\"INSURANCE\",\"entryTypes\":[\"INCOME\",\"EXPENSE\"]},{\"name\":\"Food & Drinks\",\"iconType\":\"FOOD_AND_DRINKS\",\"entryTypes\":[\"EXPENSE\"]},{\"name\":\"Misc\",\"iconType\":\"MISC\",\"entryTypes\":[\"INCOME\",\"EXPENSE\"]},{\"name\":\"Transfer\",\"iconType\":\"TRANSFER\",\"entryTypes\":[\"INCOME\",\"EXPENSE\"]},{\"name\":\"Lend\",\"iconType\":\"LEND\",\"entryTypes\":[\"INCOME\",\"EXPENSE\"]},{\"name\":\"Borrow\",\"iconType\":\"BORROW\",\"entryTypes\":[\"INCOME\",\"EXPENSE\"]}],\"places\":[{\"id\":\"EA04F4B6-9129-430C-89BE-0C1CC902E21F\",\"name\":\"Adyar Bakery\",\"address\":\"Kalakshetra Road\"},{\"id\":\"FC7E33F2-6A12-40C5-A6F7-748159E8E5C8\",\"name\":\"Star Briyani\",\"address\":\"GST, Guduvanchery\"}],\"createdOnDate\":\"YnBsaXN0MDDUAQIDBAUGExRYJHZlcnNpb25YJG9iamVjdHNZJGFyY2hpdmVyVCR0b3ASAAGGoKMHCA1VJG51bGzSCQoLDFdOUy50aW1lViRjbGFzcyNBwQLySAd3dYAC0g4PEBFaJGNsYXNzbmFtZVgkY2xhc3Nlc1ZOU0RhdGWiEBJYTlNPYmplY3RfEA9OU0tleWVkQXJjaGl2ZXLRFRZUcm9vdIABCBEaIy0yNztBRk5VXmBlcHmAg4yeoaYAAAAAAAABAQAAAAAAAAAXAAAAAAAAAAAAAAAAAAAAqA==\"}"
