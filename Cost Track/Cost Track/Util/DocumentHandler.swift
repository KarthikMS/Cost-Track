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
	private let networkHandler = NetworkHandler()
	private var queuedDeltaComps = [DocumentContentOperation.Component]()

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

	func saveDocument() {
		document.lastModifiedOnDate = Date().data
		if ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] == nil {
			// Code does not execute when tests are running
			CTFileManager.saveDocument(document)
			networkHandler.saveDocument(document)
		}
	}

}

extension DocumentHandler: DocumentModel {

	// MARK: Place
	func getDocument() -> Document {
		return document
	}

	func deleteDocument() {
		document = Document.new
		saveDocument()
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
		let renameComp = DeltaUtil.getComponentToRenameGroup(at: index, to: newName, in: document)
		sendDeltaComponents([renameComp])
	}

	func reorderGroup(from fromIndex: Int, to toIndex: Int) {
		let deltaComps = DeltaUtil.getComponentToReorderGroup(from: fromIndex, to: toIndex, in: document)
		sendDeltaComponents(deltaComps)
	}

	// MARK: Entry
	func insertCostSheetEntry(_ newEntry: CostSheetEntry, inCostSheetWithId costSheetId: String, waitForFurtherCommands: Bool = false) {
		let insertEntryComp = DeltaUtil.getComponentToInsertEntry(newEntry, inCostSheetWithId: costSheetId, document: document)
		queuedDeltaComps.append(insertEntryComp)
		guard !waitForFurtherCommands else { return }

		sendDeltaComponents(queuedDeltaComps)
		queuedDeltaComps.removeAll()
	}

	func deleteCostSheetEntry(withId entryId: String, inCostSheetWithId costSheetId: String, waitForFurtherCommands: Bool = false) {
		let deleteEntryComp = DeltaUtil.getComponentToDeleteEntry(withId: entryId, inCostSheetWithId: costSheetId, document: document)
		var deltaComps = [deleteEntryComp]

		// Deleting transferEntry if any
		let entryToDelete = document.costSheetWithId(costSheetId)!.entryWithId(entryId)
		if let entryToDeleteCategory = document.getCategory(withId: entryToDelete.categoryID),
			entryToDeleteCategory.name == "Transfer" {
			let deleteTransferEntryComp = DeltaUtil.getComponentToDeleteEntry(withId: entryToDelete.transferEntryID, inCostSheetWithId: entryToDelete.transferCostSheetID, document: document)
			deltaComps.append(deleteTransferEntryComp)
		}

		queuedDeltaComps.append(contentsOf: deltaComps)
		guard !waitForFurtherCommands else { return }
		
		sendDeltaComponents(queuedDeltaComps)
		queuedDeltaComps.removeAll()
	}

	func updateCostSheetEntry(_ updatedEntry: CostSheetEntry, inCostSheetWithId costSheetId: String, waitForFurtherCommands: Bool = false) {
		let updateEntryComp = DeltaUtil.getComponentToUpdateEntry(updatedEntry, inCostSheetWithId: costSheetId, document: document)
		queuedDeltaComps.append(updateEntryComp)
		guard !waitForFurtherCommands else { return }

		sendDeltaComponents(queuedDeltaComps)
		queuedDeltaComps.removeAll()
	}

	func transferEntry(withId entryId: String, fromCostSheetWithId fromCostSheetId: String, toCostSheetWithId toCostSheetId: String, waitForFurtherCommands: Bool = false) {
		let transferEntryComps = DeltaUtil.getComponentsToTransferEntry(withId: entryId, fromCostSheetWithId: fromCostSheetId, toCostSheetWithId: toCostSheetId, in: document)
		queuedDeltaComps.append(contentsOf: transferEntryComps)
		guard !waitForFurtherCommands else { return }

		sendDeltaComponents(queuedDeltaComps)
		queuedDeltaComps.removeAll()
	}

	// MARK: CostSheet
	func addCostSheet(_ costSheet: CostSheet) {
		let insertCostSheetComp = DeltaUtil.getComponentToInsertCostSheet(costSheet, in: document)
		sendDeltaComponents([insertCostSheetComp])
	}

	func deleteCostSheet(withId id: String) {
		let deleteCostSheetComp = DeltaUtil.getComponentToDeleteCostSheet(withId: id, in: document)
		sendDeltaComponents([deleteCostSheetComp])
	}

	func updateCostSheet(_ updatedCostSheet: CostSheet) {
		var costSheet = updatedCostSheet
		costSheet.lastModifiedDate = Date().data
		let updateCostSheetComp = DeltaUtil.getComponentToUpdateCostSheet(costSheet, in: document)
		sendDeltaComponents([updateCostSheetComp])
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
		saveDocument()
	}

}

// WARNING: Added only for testing purposes. Should be removed for release build.
var documentJSON = "{\"costSheets\":[{\"name\":\"Purse\",\"initialBalance\":2000,\"includeInOverallTotal\":true,\"groupId\":\"5494DE8C-C26C-4458-BC31-FE0182936F72\",\"entries\":[{\"type\":\"EXPENSE\",\"amount\":120,\"categoryId\":\"87B47621-739C-4D03-B4D1-1533DE31E75E\",\"placeId\":\"CD18AF45-2E91-46ED-8430-AA6CFC7E65EE\",\"date\":\"YnBsaXN0MDDUAQIDBAUGExRYJHZlcnNpb25YJG9iamVjdHNZJGFyY2hpdmVyVCR0b3ASAAGGoKMHCA1VJG51bGzSCQoLDFdOUy50aW1lViRjbGFzcyNBwQWlrQAAAIAC0g4PEBFaJGNsYXNzbmFtZVgkY2xhc3Nlc1ZOU0RhdGWiEBJYTlNPYmplY3RfEA9OU0tleWVkQXJjaGl2ZXLRFRZUcm9vdIABCBEaIy0yNztBRk5VXmBlcHmAg4yeoaYAAAAAAAABAQAAAAAAAAAXAAAAAAAAAAAAAAAAAAAAqA==\",\"description\":\"Samosa\",\"id\":\"8A2F5FB9-581A-4A57-AFA5-7DF091EAF492\"},{\"type\":\"EXPENSE\",\"amount\":460,\"categoryId\":\"87B47621-739C-4D03-B4D1-1533DE31E75E\",\"placeId\":\"1AAA77F9-CE12-4659-91FE-9582CCD19802\",\"date\":\"YnBsaXN0MDDUAQIDBAUGExRYJHZlcnNpb25YJG9iamVjdHNZJGFyY2hpdmVyVCR0b3ASAAGGoKMHCA1VJG51bGzSCQoLDFdOUy50aW1lViRjbGFzcyNBwQhIzDTCJ4AC0g4PEBFaJGNsYXNzbmFtZVgkY2xhc3Nlc1ZOU0RhdGWiEBJYTlNPYmplY3RfEA9OU0tleWVkQXJjaGl2ZXLRFRZUcm9vdIABCBEaIy0yNztBRk5VXmBlcHmAg4yeoaYAAAAAAAABAQAAAAAAAAAXAAAAAAAAAAAAAAAAAAAAqA==\",\"description\":\"\",\"id\":\"D569A802-FDA7-4731-B9A8-921BB1D0FB46\"}],\"lastModifiedDate\":\"YnBsaXN0MDDUAQIDBAUGExRYJHZlcnNpb25YJG9iamVjdHNZJGFyY2hpdmVyVCR0b3ASAAGGoKMHCA1VJG51bGzSCQoLDFdOUy50aW1lViRjbGFzcyNBwQhIePTMvIAC0g4PEBFaJGNsYXNzbmFtZVgkY2xhc3Nlc1ZOU0RhdGWiEBJYTlNPYmplY3RfEA9OU0tleWVkQXJjaGl2ZXLRFRZUcm9vdIABCBEaIy0yNztBRk5VXmBlcHmAg4yeoaYAAAAAAAABAQAAAAAAAAAXAAAAAAAAAAAAAAAAAAAAqA==\",\"createdOnDate\":\"YnBsaXN0MDDUAQIDBAUGExRYJHZlcnNpb25YJG9iamVjdHNZJGFyY2hpdmVyVCR0b3ASAAGGoKMHCA1VJG51bGzSCQoLDFdOUy50aW1lViRjbGFzcyNBwQhIePTMvIAC0g4PEBFaJGNsYXNzbmFtZVgkY2xhc3Nlc1ZOU0RhdGWiEBJYTlNPYmplY3RfEA9OU0tleWVkQXJjaGl2ZXLRFRZUcm9vdIABCBEaIy0yNztBRk5VXmBlcHmAg4yeoaYAAAAAAAABAQAAAAAAAAAXAAAAAAAAAAAAAAAAAAAAqA==\",\"id\":\"A3F74B6D-3CEF-4A5A-8990-B48AEBA80E22\"},{\"name\":\"Aditya Birla Sun Life\",\"initialBalance\":12000,\"includeInOverallTotal\":true,\"groupId\":\"5F0B4D53-2EDF-4CB1-838A-437D813A27DC\",\"lastModifiedDate\":\"YnBsaXN0MDDUAQIDBAUGExRYJHZlcnNpb25YJG9iamVjdHNZJGFyY2hpdmVyVCR0b3ASAAGGoKMHCA1VJG51bGzSCQoLDFdOUy50aW1lViRjbGFzcyNBwQhIhC1T1oAC0g4PEBFaJGNsYXNzbmFtZVgkY2xhc3Nlc1ZOU0RhdGWiEBJYTlNPYmplY3RfEA9OU0tleWVkQXJjaGl2ZXLRFRZUcm9vdIABCBEaIy0yNztBRk5VXmBlcHmAg4yeoaYAAAAAAAABAQAAAAAAAAAXAAAAAAAAAAAAAAAAAAAAqA==\",\"createdOnDate\":\"YnBsaXN0MDDUAQIDBAUGExRYJHZlcnNpb25YJG9iamVjdHNZJGFyY2hpdmVyVCR0b3ASAAGGoKMHCA1VJG51bGzSCQoLDFdOUy50aW1lViRjbGFzcyNBwQhIhC1T1oAC0g4PEBFaJGNsYXNzbmFtZVgkY2xhc3Nlc1ZOU0RhdGWiEBJYTlNPYmplY3RfEA9OU0tleWVkQXJjaGl2ZXLRFRZUcm9vdIABCBEaIy0yNztBRk5VXmBlcHmAg4yeoaYAAAAAAAABAQAAAAAAAAAXAAAAAAAAAAAAAAAAAAAAqA==\",\"id\":\"8A80B391-D7D0-4F7C-AEAC-62D7768DB43A\"},{\"name\":\"Paytm\",\"initialBalance\":500,\"includeInOverallTotal\":true,\"groupId\":\"A0FD94A4-0EE3-457F-B396-6AA45FFDEED2\",\"entries\":[{\"type\":\"INCOME\",\"amount\":1000,\"categoryId\":\"85B784C1-57EF-4127-A6C8-AE78BFC0D37E\",\"date\":\"YnBsaXN0MDDUAQIDBAUGExRYJHZlcnNpb25YJG9iamVjdHNZJGFyY2hpdmVyVCR0b3ASAAGGoKMHCA1VJG51bGzSCQoLDFdOUy50aW1lViRjbGFzcyNBwQhI9f0Lr4AC0g4PEBFaJGNsYXNzbmFtZVgkY2xhc3Nlc1ZOU0RhdGWiEBJYTlNPYmplY3RfEA9OU0tleWVkQXJjaGl2ZXLRFRZUcm9vdIABCBEaIy0yNztBRk5VXmBlcHmAg4yeoaYAAAAAAAABAQAAAAAAAAAXAAAAAAAAAAAAAAAAAAAAqA==\",\"description\":\"Paytm Recharge\",\"id\":\"481C67AE-28B3-41FF-A679-5588DE723DA7\",\"transferCostSheetId\":\"879D2D17-D18C-4BD8-9ADF-03255BC8F715\",\"transferEntryId\":\"C5422630-A8C0-4AD4-A3AC-9E94874A2674\"}],\"lastModifiedDate\":\"YnBsaXN0MDDUAQIDBAUGExRYJHZlcnNpb25YJG9iamVjdHNZJGFyY2hpdmVyVCR0b3ASAAGGoKMHCA1VJG51bGzSCQoLDFdOUy50aW1lViRjbGFzcyNBwQhIjjO+y4AC0g4PEBFaJGNsYXNzbmFtZVgkY2xhc3Nlc1ZOU0RhdGWiEBJYTlNPYmplY3RfEA9OU0tleWVkQXJjaGl2ZXLRFRZUcm9vdIABCBEaIy0yNztBRk5VXmBlcHmAg4yeoaYAAAAAAAABAQAAAAAAAAAXAAAAAAAAAAAAAAAAAAAAqA==\",\"createdOnDate\":\"YnBsaXN0MDDUAQIDBAUGExRYJHZlcnNpb25YJG9iamVjdHNZJGFyY2hpdmVyVCR0b3ASAAGGoKMHCA1VJG51bGzSCQoLDFdOUy50aW1lViRjbGFzcyNBwQhIjjO+y4AC0g4PEBFaJGNsYXNzbmFtZVgkY2xhc3Nlc1ZOU0RhdGWiEBJYTlNPYmplY3RfEA9OU0tleWVkQXJjaGl2ZXLRFRZUcm9vdIABCBEaIy0yNztBRk5VXmBlcHmAg4yeoaYAAAAAAAABAQAAAAAAAAAXAAAAAAAAAAAAAAAAAAAAqA==\",\"id\":\"EAF6E6DA-8708-4EA7-A1FA-75D518C427F4\"},{\"name\":\"HDFC Savings\",\"initialBalance\":50000,\"includeInOverallTotal\":true,\"groupId\":\"93C0B3FC-9635-48E1-AE92-1D5AE09D0248\",\"entries\":[{\"type\":\"EXPENSE\",\"amount\":1000,\"categoryId\":\"85B784C1-57EF-4127-A6C8-AE78BFC0D37E\",\"date\":\"YnBsaXN0MDDUAQIDBAUGExRYJHZlcnNpb25YJG9iamVjdHNZJGFyY2hpdmVyVCR0b3ASAAGGoKMHCA1VJG51bGzSCQoLDFdOUy50aW1lViRjbGFzcyNBwQhI9f0Lr4AC0g4PEBFaJGNsYXNzbmFtZVgkY2xhc3Nlc1ZOU0RhdGWiEBJYTlNPYmplY3RfEA9OU0tleWVkQXJjaGl2ZXLRFRZUcm9vdIABCBEaIy0yNztBRk5VXmBlcHmAg4yeoaYAAAAAAAABAQAAAAAAAAAXAAAAAAAAAAAAAAAAAAAAqA==\",\"description\":\"Paytm Recharge\",\"id\":\"C5422630-A8C0-4AD4-A3AC-9E94874A2674\",\"transferCostSheetId\":\"EAF6E6DA-8708-4EA7-A1FA-75D518C427F4\",\"transferEntryId\":\"481C67AE-28B3-41FF-A679-5588DE723DA7\"}],\"lastModifiedDate\":\"YnBsaXN0MDDUAQIDBAUGExRYJHZlcnNpb25YJG9iamVjdHNZJGFyY2hpdmVyVCR0b3ASAAGGoKMHCA1VJG51bGzSCQoLDFdOUy50aW1lViRjbGFzcyNBwQhIoRCNIoAC0g4PEBFaJGNsYXNzbmFtZVgkY2xhc3Nlc1ZOU0RhdGWiEBJYTlNPYmplY3RfEA9OU0tleWVkQXJjaGl2ZXLRFRZUcm9vdIABCBEaIy0yNztBRk5VXmBlcHmAg4yeoaYAAAAAAAABAQAAAAAAAAAXAAAAAAAAAAAAAAAAAAAAqA==\",\"createdOnDate\":\"YnBsaXN0MDDUAQIDBAUGExRYJHZlcnNpb25YJG9iamVjdHNZJGFyY2hpdmVyVCR0b3ASAAGGoKMHCA1VJG51bGzSCQoLDFdOUy50aW1lViRjbGFzcyNBwQhIoRCNIoAC0g4PEBFaJGNsYXNzbmFtZVgkY2xhc3Nlc1ZOU0RhdGWiEBJYTlNPYmplY3RfEA9OU0tleWVkQXJjaGl2ZXLRFRZUcm9vdIABCBEaIy0yNztBRk5VXmBlcHmAg4yeoaYAAAAAAAABAQAAAAAAAAAXAAAAAAAAAAAAAAAAAAAAqA==\",\"id\":\"879D2D17-D18C-4BD8-9ADF-03255BC8F715\"}],\"groups\":[{\"name\":\"Not set\",\"id\":\"5494DE8C-C26C-4458-BC31-FE0182936F72\"},{\"name\":\"Savings Accounts\",\"id\":\"93C0B3FC-9635-48E1-AE92-1D5AE09D0248\"},{\"name\":\"Phone Wallets\",\"id\":\"A0FD94A4-0EE3-457F-B396-6AA45FFDEED2\"},{\"name\":\"Mutual Funds\",\"id\":\"5F0B4D53-2EDF-4CB1-838A-437D813A27DC\"},{\"name\":\"Cards\",\"id\":\"80F15957-6CD5-4792-ADD7-A65293A48481\"}],\"categories\":[{\"name\":\"Salary\",\"iconType\":\"SALARY\",\"entryTypes\":[\"INCOME\"],\"id\":\"1561E857-B382-42DE-841F-8F3E32EAA82E\",\"canEdit\":true},{\"name\":\"Vehicle & Transport\",\"iconType\":\"VEHICLE_AND_TRANSPORT\",\"entryTypes\":[\"EXPENSE\"],\"id\":\"E9603624-CE9F-4344-BA70-34FAA3A1492C\",\"canEdit\":true},{\"name\":\"Household\",\"iconType\":\"HOUSEHOLD\",\"entryTypes\":[\"INCOME\",\"EXPENSE\"],\"id\":\"DBB7EB3D-3ABF-4AA5-8F2A-8DB75BB59758\",\"canEdit\":true},{\"name\":\"Shopping\",\"iconType\":\"SHOPPING\",\"entryTypes\":[\"EXPENSE\"],\"id\":\"7B9C8AC0-1ECF-47BE-AECD-00D4BD6B764E\",\"canEdit\":true},{\"name\":\"Phone\",\"iconType\":\"PHONE\",\"entryTypes\":[\"EXPENSE\"],\"id\":\"38F5ADB9-FC17-4FAB-8F07-0122F37C3BE9\",\"canEdit\":true},{\"name\":\"Entertainment\",\"iconType\":\"ENTERTAINMENT\",\"entryTypes\":[\"INCOME\",\"EXPENSE\"],\"id\":\"23FEEE06-D69A-4CD8-BD4E-87E53B2B53FB\",\"canEdit\":true},{\"name\":\"Medicine\",\"iconType\":\"MEDICINE\",\"entryTypes\":[\"EXPENSE\"],\"id\":\"938BB1C1-9175-4543-862A-3183E7D72277\",\"canEdit\":true},{\"name\":\"Investment\",\"iconType\":\"INVESTMENT\",\"entryTypes\":[\"INCOME\",\"EXPENSE\"],\"id\":\"E198FB5E-E3DB-4FB3-B37B-6A6331030BB9\",\"canEdit\":true},{\"name\":\"Tax\",\"iconType\":\"TAX\",\"entryTypes\":[\"EXPENSE\"],\"id\":\"08DB35B6-AB49-47F6-85D4-2CCB42FFD30D\",\"canEdit\":true},{\"name\":\"Insurance\",\"iconType\":\"INSURANCE\",\"entryTypes\":[\"INCOME\",\"EXPENSE\"],\"id\":\"D44A718F-BD17-44A4-9921-59D89E0FA5E1\",\"canEdit\":true},{\"name\":\"Food & Drinks\",\"iconType\":\"FOOD_AND_DRINKS\",\"entryTypes\":[\"EXPENSE\"],\"id\":\"87B47621-739C-4D03-B4D1-1533DE31E75E\",\"canEdit\":true},{\"name\":\"Misc\",\"iconType\":\"MISC\",\"entryTypes\":[\"INCOME\",\"EXPENSE\"],\"id\":\"3984AD0F-9536-4591-97EB-A7F4FF4D21F7\",\"canEdit\":true},{\"name\":\"Transfer\",\"iconType\":\"TRANSFER\",\"entryTypes\":[\"INCOME\",\"EXPENSE\"],\"id\":\"85B784C1-57EF-4127-A6C8-AE78BFC0D37E\",\"canEdit\":true},{\"name\":\"Lend\",\"iconType\":\"LEND\",\"entryTypes\":[\"INCOME\",\"EXPENSE\"],\"id\":\"72866536-79F6-4938-8390-D912A8898E96\",\"canEdit\":false},{\"name\":\"Borrow\",\"iconType\":\"BORROW\",\"entryTypes\":[\"INCOME\",\"EXPENSE\"],\"id\":\"EA5A9FAE-D7C9-44DC-937B-6FFA8ACCD485\",\"canEdit\":false}],\"places\":[{\"id\":\"CD18AF45-2E91-46ED-8430-AA6CFC7E65EE\",\"name\":\"Adyar Bakery\",\"address\":\"Kalakshetra Road, Thiruvanmiyur\"},{\"id\":\"1AAA77F9-CE12-4659-91FE-9582CCD19802\",\"name\":\"Star Briyani\",\"address\":\"GST Road, Guduvancheri\"}],\"createdOnDate\":\"YnBsaXN0MDDUAQIDBAUGExRYJHZlcnNpb25YJG9iamVjdHNZJGFyY2hpdmVyVCR0b3ASAAGGoKMHCA1VJG51bGzSCQoLDFdOUy50aW1lViRjbGFzcyNBwQhICHUN6YAC0g4PEBFaJGNsYXNzbmFtZVgkY2xhc3Nlc1ZOU0RhdGWiEBJYTlNPYmplY3RfEA9OU0tleWVkQXJjaGl2ZXLRFRZUcm9vdIABCBEaIy0yNztBRk5VXmBlcHmAg4yeoaYAAAAAAAABAQAAAAAAAAAXAAAAAAAAAAAAAAAAAAAAqA==\",\"lastModifiedOnDate\":\"YnBsaXN0MDDUAQIDBAUGExRYJHZlcnNpb25YJG9iamVjdHNZJGFyY2hpdmVyVCR0b3ASAAGGoKMHCA1VJG51bGzSCQoLDFdOUy50aW1lViRjbGFzcyNBwQhJAddpkIAC0g4PEBFaJGNsYXNzbmFtZVgkY2xhc3Nlc1ZOU0RhdGWiEBJYTlNPYmplY3RfEA9OU0tleWVkQXJjaGl2ZXLRFRZUcm9vdIABCBEaIy0yNztBRk5VXmBlcHmAg4yeoaYAAAAAAAABAQAAAAAAAAAXAAAAAAAAAAAAAAAAAAAAqA==\"}"
