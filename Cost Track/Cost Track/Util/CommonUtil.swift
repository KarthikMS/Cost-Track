//
//  CommonUtil.swift
//  Cost Track
//
//  Created by Karthik M S on 05/08/18.
//  Copyright © 2018 Karthik M S. All rights reserved.
//

import Foundation

class CommonUtil {

	static func getAllCategories() -> [CostSheetEntry.Category] {
		return [
			CostSheetEntry.Category.entertainment,
			CostSheetEntry.Category.foodAndDrinks,
			CostSheetEntry.Category.vehicleAndTransport,
			CostSheetEntry.Category.salary,
			CostSheetEntry.Category.shopping,

			CostSheetEntry.Category.household,
			CostSheetEntry.Category.phone,
			CostSheetEntry.Category.investment,
			CostSheetEntry.Category.investmentReturn,
			CostSheetEntry.Category.insurance,

			CostSheetEntry.Category.medicine,
			CostSheetEntry.Category.tax,
			CostSheetEntry.Category.misc,
			CostSheetEntry.Category.transfer
		]
	}

}
