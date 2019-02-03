//
//  NetworkHandler.swift
//  Cost Track
//
//  Created by Karthik M S on 03/02/19.
//  Copyright © 2019 Karthik M S. All rights reserved.
//

import Foundation

class NetworkHandler {

	private let firebaseHandler = FirebaseHandler()

}

extension NetworkHandler: Networking {

	func saveDocument(_ document: Document) {
		firebaseHandler.saveDocument(document)
	}

}
