//
//  CTFileManager.swift
//  Cost Track
//
//  Created by Karthik M S on 18/09/18.
//  Copyright © 2018 Karthik M S. All rights reserved.
//

import Foundation

class CTFileManager {

	private static var userDocumentUrl: URL? {
		let directories = NSSearchPathForDirectoriesInDomains(.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
		guard let documents = directories.first,
			let urlDocuments = NSURL(string: documents),
			let userDocumentURL = urlDocuments.appendingPathComponent("UserDocument.dat") else {
				assertionFailure("Could not get url")
				return nil
		}
		return userDocumentURL
	}

	static func getDocument() -> (document: Document, shouldSave: Bool) {
		guard let userDocumentUrl = userDocumentUrl else {
			assertionFailure()
			return (Document(), false)
		}
		do {
			// Checking if document already exists
			let loadedDocData = try NSData(contentsOfFile: userDocumentUrl.path) as Data
			let loadedDoc = try Document(serializedData: loadedDocData)

			// Setting NotSetGroup
			for group in loadedDoc.groups where group.name == "Not set" {
				NotSetGroup = group
			}

			return (loadedDoc, false)
		} catch {
			let newDoc = Document.new
			return (newDoc, true)
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
