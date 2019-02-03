//
//  FirebaseHandler.swift
//  Cost Track
//
//  Created by Karthik M S on 03/02/19.
//  Copyright © 2019 Karthik M S. All rights reserved.
//

import Foundation
import FirebaseDatabase

class FirebaseHandler {

	private let databaseRef = Database.database().reference()

}

extension FirebaseHandler: Networking {

	func saveDocument(_ document: Document) {
		do {
			let documentJson = try document.jsonString()
			databaseRef.child("documentJson").setValue(documentJson)
		} catch {
			assertionFailure("Error converting document to json: \(error.localizedDescription)")
		}
	}

}
