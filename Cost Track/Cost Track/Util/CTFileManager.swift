//
//  CTFileManager.swift
//  Cost Track
//
//  Created by Karthik M S on 18/09/18.
//  Copyright © 2018 Karthik M S. All rights reserved.
//

import Foundation

class CTFileManager {

	static var userDocumentUrl: URL? {
		let directories = NSSearchPathForDirectoriesInDomains(.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
		guard let documents = directories.first,
			let urlDocuments = NSURL(string: documents),
			let userDocumentURL = urlDocuments.appendingPathComponent("UserDocument.dat") else {
				assertionFailure("Could not get url")
				return nil
		}
		return userDocumentURL
	}

	static func getDocument() -> Document {
		guard let userDocumentUrl = userDocumentUrl else {
			assertionFailure()
			return Document()
		}
		do {
			let loadedDocumentData = try NSData(contentsOfFile: userDocumentUrl.path) as Data
			let loadedDocument = try Document(serializedData: loadedDocumentData)
			return loadedDocument
		} catch {
			// Setting NotSetGroup. Should happen only once in app's life time.
			var document = Document()
			if document.groups.isEmpty {
				var notSetGroup = CostSheetGroup()
				notSetGroup.name = "Not set"
				notSetGroup.id = UUID().uuidString
				document.groups.append(notSetGroup)

				NotSetGroup = notSetGroup
			}
			return document
		}
	}

	static func saveDocument(_ document: Document) {
		guard let userDocumentUrl = userDocumentUrl else {
			assertionFailure()
			return
		}
		let documentData = document.safeSerializedData as NSData
		documentData.write(toFile: userDocumentUrl.path, atomically: true)
	}

	static func deleteDocument() {
		guard let userDocumentUrl = userDocumentUrl else {
			assertionFailure()
			return
		}
		let fileManager = FileManager.default
		do {
			try fileManager.removeItem(atPath: userDocumentUrl.path)
		} catch {
			print("Error deleting document: \(error.localizedDescription)")
			assertionFailure()
		}
	}

}
