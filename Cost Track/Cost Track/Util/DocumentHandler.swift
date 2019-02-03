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
		// Comment and use the next block of code to use json document
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
		document = Document.new
		if ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] == nil {
			// Code does not execute when tests are running
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
		let moveCostSheetsComps = DeltaUtil.getComponentsToMoveCostSheets(fromGroupWithId: document.groups[index].id, toGroupWithId: NotSetGroupId, in: document)
		let deltaComps = [deleteGroupComp] + moveCostSheetsComps
		sendDeltaComponents(deltaComps)
	}

	func renameGroupAt(_ index: Int, to newName: String) {
		let renameComp = DeltaUtil.getComponentToRenameGroup(at: index, to: newName, in: getDocument())
		sendDeltaComponents([renameComp])
	}

	func reorderGroup(from fromIndex: Int, to toIndex: Int) {
		let deltaComps = DeltaUtil.getComponentToReorderGroup(from: fromIndex, to: toIndex, in: getDocument())
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
			// Code does not execute when tests are running
			CTFileManager.saveDocument(document)
		}
	}

}

var documentJSON = "{\"costSheets\":[{\"name\":\"Purse\",\"initialBalance\":2000,\"includeInOverallTotal\":true,\"groupId\":\"3998D418-3DEA-4812-A3D4-F91895100C2B\",\"entries\":[{\"type\":\"EXPENSE\",\"amount\":120,\"category\":{\"name\":\"Food & Drinks\",\"iconType\":\"FOOD_AND_DRINKS\",\"entryTypes\":[\"EXPENSE\"]},\"placeId\":\"F3337A65-7641-406B-9AA2-EF6A439963F8\",\"date\":\"YnBsaXN0MDDUAQIDBAUGExRYJHZlcnNpb25YJG9iamVjdHNZJGFyY2hpdmVyVCR0b3ASAAGGoKMHCA1VJG51bGzSCQoLDFdOUy50aW1lViRjbGFzcyNBwQDWZwAAAIAC0g4PEBFaJGNsYXNzbmFtZVgkY2xhc3Nlc1ZOU0RhdGWiEBJYTlNPYmplY3RfEA9OU0tleWVkQXJjaGl2ZXLRFRZUcm9vdIABCBEaIy0yNztBRk5VXmBlcHmAg4yeoaYAAAAAAAABAQAAAAAAAAAXAAAAAAAAAAAAAAAAAAAAqA==\",\"description\":\"Samosa\",\"id\":\"1D2C75A9-17CE-4B12-8AEC-915E6525ECE2\"},{\"type\":\"EXPENSE\",\"amount\":460,\"category\":{\"name\":\"Food & Drinks\",\"iconType\":\"FOOD_AND_DRINKS\",\"entryTypes\":[\"EXPENSE\"]},\"placeId\":\"3574094D-3D0A-4F01-8F06-210CCB5F10B1\",\"date\":\"YnBsaXN0MDDUAQIDBAUGExRYJHZlcnNpb25YJG9iamVjdHNZJGFyY2hpdmVyVCR0b3ASAAGGoKMHCA1VJG51bGzSCQoLDFdOUy50aW1lViRjbGFzcyNBwQQiZQAAAIAC0g4PEBFaJGNsYXNzbmFtZVgkY2xhc3Nlc1ZOU0RhdGWiEBJYTlNPYmplY3RfEA9OU0tleWVkQXJjaGl2ZXLRFRZUcm9vdIABCBEaIy0yNztBRk5VXmBlcHmAg4yeoaYAAAAAAAABAQAAAAAAAAAXAAAAAAAAAAAAAAAAAAAAqA==\",\"description\":\"\",\"id\":\"5539BD33-2BDF-4B85-8439-3045534EB653\"}],\"lastModifiedDate\":\"YnBsaXN0MDDUAQIDBAUGExRYJHZlcnNpb25YJG9iamVjdHNZJGFyY2hpdmVyVCR0b3ASAAGGoKMHCA1VJG51bGzSCQoLDFdOUy50aW1lViRjbGFzcyNBwQN5YGBeaIAC0g4PEBFaJGNsYXNzbmFtZVgkY2xhc3Nlc1ZOU0RhdGWiEBJYTlNPYmplY3RfEA9OU0tleWVkQXJjaGl2ZXLRFRZUcm9vdIABCBEaIy0yNztBRk5VXmBlcHmAg4yeoaYAAAAAAAABAQAAAAAAAAAXAAAAAAAAAAAAAAAAAAAAqA==\",\"createdOnDate\":\"YnBsaXN0MDDUAQIDBAUGExRYJHZlcnNpb25YJG9iamVjdHNZJGFyY2hpdmVyVCR0b3ASAAGGoKMHCA1VJG51bGzSCQoLDFdOUy50aW1lViRjbGFzcyNBwQN5YGBeaIAC0g4PEBFaJGNsYXNzbmFtZVgkY2xhc3Nlc1ZOU0RhdGWiEBJYTlNPYmplY3RfEA9OU0tleWVkQXJjaGl2ZXLRFRZUcm9vdIABCBEaIy0yNztBRk5VXmBlcHmAg4yeoaYAAAAAAAABAQAAAAAAAAAXAAAAAAAAAAAAAAAAAAAAqA==\",\"id\":\"D4980A2D-AB07-4DE8-BE98-E6BED6AB424A\"},{\"name\":\"Aditya Birla Sun Life\",\"initialBalance\":12000,\"includeInOverallTotal\":true,\"groupId\":\"B251159F-31FC-4582-AD5F-B2F53CD624E9\",\"lastModifiedDate\":\"YnBsaXN0MDDUAQIDBAUGExRYJHZlcnNpb25YJG9iamVjdHNZJGFyY2hpdmVyVCR0b3ASAAGGoKMHCA1VJG51bGzSCQoLDFdOUy50aW1lViRjbGFzcyNBwQN54nBwVIAC0g4PEBFaJGNsYXNzbmFtZVgkY2xhc3Nlc1ZOU0RhdGWiEBJYTlNPYmplY3RfEA9OU0tleWVkQXJjaGl2ZXLRFRZUcm9vdIABCBEaIy0yNztBRk5VXmBlcHmAg4yeoaYAAAAAAAABAQAAAAAAAAAXAAAAAAAAAAAAAAAAAAAAqA==\",\"createdOnDate\":\"YnBsaXN0MDDUAQIDBAUGExRYJHZlcnNpb25YJG9iamVjdHNZJGFyY2hpdmVyVCR0b3ASAAGGoKMHCA1VJG51bGzSCQoLDFdOUy50aW1lViRjbGFzcyNBwQN53NPQ8oAC0g4PEBFaJGNsYXNzbmFtZVgkY2xhc3Nlc1ZOU0RhdGWiEBJYTlNPYmplY3RfEA9OU0tleWVkQXJjaGl2ZXLRFRZUcm9vdIABCBEaIy0yNztBRk5VXmBlcHmAg4yeoaYAAAAAAAABAQAAAAAAAAAXAAAAAAAAAAAAAAAAAAAAqA==\",\"id\":\"637E3507-5B53-407D-812D-04DB37D14727\"}],\"groups\":[{\"name\":\"Not set\",\"id\":\"3998D418-3DEA-4812-A3D4-F91895100C2B\"},{\"name\":\"Mutual Funds\",\"id\":\"B251159F-31FC-4582-AD5F-B2F53CD624E9\"},{\"name\":\"Savings Accounts\",\"id\":\"E68620E1-9E93-4E2A-BD29-3FC0EA3440AB\"},{\"name\":\"Cards\",\"id\":\"A2F4EB21-3479-477B-8DE8-CF9BA1EE386F\"},{\"name\":\"Phone Wallets\",\"id\":\"183DC1A8-7568-4A13-ADB6-0039B02DDC61\"}],\"categories\":[{\"name\":\"Salary\",\"iconType\":\"SALARY\",\"entryTypes\":[\"INCOME\"]},{\"name\":\"Vehicle & Transport\",\"iconType\":\"VEHICLE_AND_TRANSPORT\",\"entryTypes\":[\"EXPENSE\"]},{\"name\":\"Household\",\"iconType\":\"HOUSEHOLD\",\"entryTypes\":[\"INCOME\",\"EXPENSE\"]},{\"name\":\"Shopping\",\"iconType\":\"SHOPPING\",\"entryTypes\":[\"EXPENSE\"]},{\"name\":\"Phone\",\"iconType\":\"PHONE\",\"entryTypes\":[\"EXPENSE\"]},{\"name\":\"Entertainment\",\"iconType\":\"ENTERTAINMENT\",\"entryTypes\":[\"INCOME\",\"EXPENSE\"]},{\"name\":\"Medicine\",\"iconType\":\"MEDICINE\",\"entryTypes\":[\"EXPENSE\"]},{\"name\":\"Investment\",\"iconType\":\"INVESTMENT\",\"entryTypes\":[\"INCOME\",\"EXPENSE\"]},{\"name\":\"Tax\",\"iconType\":\"TAX\",\"entryTypes\":[\"EXPENSE\"]},{\"name\":\"Insurance\",\"iconType\":\"INSURANCE\",\"entryTypes\":[\"INCOME\",\"EXPENSE\"]},{\"name\":\"Food & Drinks\",\"iconType\":\"FOOD_AND_DRINKS\",\"entryTypes\":[\"EXPENSE\"]},{\"name\":\"Misc\",\"iconType\":\"MISC\",\"entryTypes\":[\"INCOME\",\"EXPENSE\"]},{\"name\":\"Transfer\",\"iconType\":\"TRANSFER\",\"entryTypes\":[\"INCOME\",\"EXPENSE\"]},{\"name\":\"Lend\",\"iconType\":\"LEND\",\"entryTypes\":[\"INCOME\",\"EXPENSE\"]},{\"name\":\"Borrow\",\"iconType\":\"BORROW\",\"entryTypes\":[\"INCOME\",\"EXPENSE\"]}],\"places\":[{\"id\":\"F3337A65-7641-406B-9AA2-EF6A439963F8\",\"name\":\"Adyar Bakery\",\"address\":\"Kalakshetra Road, Thiruvanmiyur\"},{\"id\":\"3574094D-3D0A-4F01-8F06-210CCB5F10B1\",\"name\":\"Star Briyani\",\"address\":\"GST Road, Guduvanchery\"}],\"createdOnDate\":\"YnBsaXN0MDDUAQIDBAUGExRYJHZlcnNpb25YJG9iamVjdHNZJGFyY2hpdmVyVCR0b3ASAAGGoKMHCA1VJG51bGzSCQoLDFdOUy50aW1lViRjbGFzcyNBwQN5TDhVl4AC0g4PEBFaJGNsYXNzbmFtZVgkY2xhc3Nlc1ZOU0RhdGWiEBJYTlNPYmplY3RfEA9OU0tleWVkQXJjaGl2ZXLRFRZUcm9vdIABCBEaIy0yNztBRk5VXmBlcHmAg4yeoaYAAAAAAAABAQAAAAAAAAAXAAAAAAAAAAAAAAAAAAAAqA==\"}"
