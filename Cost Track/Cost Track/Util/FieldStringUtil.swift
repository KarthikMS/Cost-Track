//
//  FieldStringUtil.swift
//  Cost Track
//
//  Created by Karthik M S on 03/09/18.
//  Copyright © 2018 Karthik M S. All rights reserved.
//

import Foundation

func fieldStringForCostSheet(id: String, document: Document) -> String {
	for i in 0..<document.costSheets.count where document.costSheets[i].id == id {
		return "1,arr:\(i)"
	}
	assertionFailure("Cost sheet not found")
	return ""
}

func fieldStringForGroup(id: String, document: Document) -> String {
	for i in 0..<document.groups.count where document.groups[i].id == id {
		return "2,arr:\(i)"
	}
	assertionFailure("Group not found")
	return ""
}
