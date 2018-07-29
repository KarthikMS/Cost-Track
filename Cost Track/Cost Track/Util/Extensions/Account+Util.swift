//
//  Account+Util.swift
//  Cost Track
//
//  Created by Karthik M S on 29/07/18.
//  Copyright © 2018 Karthik M S. All rights reserved.
//

import Foundation

extension Account {

	func numberOfCostSheetsInGroup(_ group: CostSheetGroup) -> Int {
		var count = 0
		for costSheet in costSheets where costSheet.group.id == group.id {
			count += 1
		}
		return count
	}

}
