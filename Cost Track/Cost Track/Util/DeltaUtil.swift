//
//  DeltaUtil.swift
//  Cost Track
//
//  Created by Karthik M S on 03/09/18.
//  Copyright © 2018 Karthik M S. All rights reserved.
//

import Foundation

protocol DeltaDelegate: class {
	func sendDeltaComponents(_ components: [DocumentContentOperation.Component])
}

class DeltaUtil {

	static func getComponent(opType: DocumentContentOperation.Component.OperationType, fieldString: String, oldValue: Data? = nil, newValue: Data? = nil) -> DocumentContentOperation.Component {
		var comp = DocumentContentOperation.Component()
		comp.opType = opType
		comp.fields = fieldString
		switch opType {
		case .insert:
			guard let newValue = newValue else {
				assertionFailure("Insert component should have newValue")
				return comp
			}
			comp.value.inBytes.value = newValue
		case .delete:
			guard let oldValue = oldValue else {
				assertionFailure("Delete component should have oldValue")
				return comp
			}
			comp.value.inBytes.oldValue = oldValue
		case .update:
			guard let oldValue = oldValue,
				let newValue = newValue else {
					assertionFailure("Update component should have oldValue and newValue")
					return comp
			}
			comp.value.inBytes.oldValue = oldValue
			comp.value.inBytes.value = newValue
		default:
			break
		}
		return comp
	}

}
