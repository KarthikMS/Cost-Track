//
//  FieldStringUtil.swift
//  Cost Track
//
//  Created by Karthik M S on 03/09/18.
//  Copyright © 2018 Karthik M S. All rights reserved.
//

import Foundation

func fieldStringForCostSheet(id: String, account: Account) -> String {
	for i in 0..<account.costSheets.count where account.costSheets[i].id == id {
		return "1,arr:\(i)"
	}
	assertionFailure("Cost sheet not found")
	return ""
}
