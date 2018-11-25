//
//  CostSheetEntry+Util.swift
//  Cost Track
//
//  Created by Karthik M S on 25/11/18.
//  Copyright © 2018 Karthik M S. All rights reserved.
//

import Foundation

extension CostSheetEntry {

	func isBetween(_ startDate: Date, and endDate: Date) -> Bool {
		guard let date = date.date else {
			assertionFailure()
			return false
		}
		return date.isBetween(startDate, and: endDate)
	}

	func isBefore(_ startDate: Date) -> Bool {
		guard let date = date.date else {
			assertionFailure()
			return false
		}
		return date.isBefore(startDate)
	}

}
