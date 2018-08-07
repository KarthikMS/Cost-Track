//
//  CostSheetEntry+Util.swift
//  Cost Track
//
//  Created by Karthik M S on 05/08/18.
//  Copyright © 2018 Karthik M S. All rights reserved.
//

import Foundation

extension CostSheetEntry.Category {

	var name: String {
		switch self {
		case .entertainment:
			return "Entertainment"
		case .foodAndDrinks:
			return "Food & Drinks"
		case .household:
			return "Household"
		case .insurance:
			return "Insurance"
		case .investment:
			return "Investment"
		case .investmentReturn:
			return "Investment Return"
		case .medicine:
			return "Medicine"
		case .misc:
			return "Misc."
		case .salary:
			return "Salary"
		case .vehicleAndTransport:
			return "Vehicle & Transport"
		case .shopping:
			return "Shopping"
		case .phone:
			return "Phone"
		case .tax:
			return "Tax"
		case .transfer:
			return "Transfer"
		}
	}

}
