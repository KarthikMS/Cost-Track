//
//  DocumentHandler.swift
//  Cost Track
//
//  Created by Karthik M S on 02/02/19.
//  Copyright © 2019 Karthik M S. All rights reserved.
//

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
		CTFileManager.deleteDocument()
		(document, _) = CTFileManager.getDocument()
		CTFileManager.saveDocument(document)
	}

	func insertPlaceWithName(_ name: String) {

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
		CTFileManager.saveDocument(document)
	}

}
