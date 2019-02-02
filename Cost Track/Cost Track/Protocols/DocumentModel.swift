//
//  DocumentModel.swift
//  Cost Track
//
//  Created by Karthik M S on 02/02/19.
//  Copyright © 2019 Karthik M S. All rights reserved.
//

protocol DocumentModelSource {
	func getDocument() -> Document
	func deleteDocument()
}

protocol DocumentModelInput {
	// Place
	func insertPlaceWithName(_ name: String)
	func deletePlaceAndClearRelatedPlaceIds(index: Int)
	func updatePlace(at index: Int, with newPlace: Place)
}

protocol DocumentModel: DocumentModelSource, DocumentModelInput {
//	func setUpWithDocument(_ document: Document)
}
