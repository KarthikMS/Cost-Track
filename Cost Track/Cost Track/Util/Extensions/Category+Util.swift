//
//  Category+Util.swift
//  Cost Track
//
//  Created by Karthik M S on 20/10/18.
//  Copyright © 2018 Karthik M S. All rights reserved.
//

import Foundation

extension Category {

	static func defaultCategories() -> [Category] {
		var salary = Category()
		salary.name = "Salary"
		salary.iconType = .salary
		salary.entryTypes.append(EntryType.income)

		var vehicleAndTransport = Category()
		vehicleAndTransport.name = "Vehicle & Transport"
		vehicleAndTransport.iconType = .vehicleAndTransport
		vehicleAndTransport.entryTypes.append(EntryType.income)

		var household = Category()
		household.name = "Household"
		household.iconType = .household
		household.entryTypes.append(contentsOf: [EntryType.income, EntryType.expense])

		var shopping = Category()
		shopping.name = "Shopping"
		shopping.iconType = .shopping
		shopping.entryTypes.append(EntryType.expense)

		var phone = Category()
		phone.name = "Phone"
		phone.iconType = .phone
		phone.entryTypes.append(EntryType.expense)

		var entertainment = Category()
		entertainment.name = "Entertainment"
		entertainment.iconType = .entertainment
		entertainment.entryTypes.append(contentsOf: [EntryType.income, EntryType.expense])

		var medicine = Category()
		medicine.name = "Medicine"
		medicine.iconType = .medicine
		medicine.entryTypes.append(EntryType.expense)

		var investment = Category()
		investment.name = "Investment"
		investment.iconType = .investment
		investment.entryTypes.append(contentsOf: [EntryType.income, EntryType.expense])

		var tax = Category()
		tax.name = "Tax"
		tax.iconType = .tax
		tax.entryTypes.append(EntryType.expense)

		var insurance = Category()
		insurance.name = "Insurance"
		insurance.iconType = .insurance
		insurance.entryTypes.append(contentsOf: [EntryType.income, EntryType.expense])

		var foodAndDrinks = Category()
		foodAndDrinks.name = "Food & Drinks"
		foodAndDrinks.iconType = .foodAndDrinks
		foodAndDrinks.entryTypes.append(EntryType.expense)

		var misc = Category()
		misc.name = "Misc"
		misc.iconType = .misc
		misc.entryTypes.append(contentsOf: [EntryType.income, EntryType.expense])

		var transfer = Category()
		transfer.name = "Transfer"
		transfer.iconType = .transfer
		transfer.entryTypes.append(contentsOf: [EntryType.income, EntryType.expense])

		var lend = Category()
		lend.name = "Lend"
		lend.iconType = .lend
		lend.entryTypes.append(contentsOf: [EntryType.income, EntryType.expense])

		var borrow = Category()
		borrow.name = "Borrow"
		borrow.iconType = .borrow
		borrow.entryTypes.append(contentsOf: [EntryType.income, EntryType.expense])

		return [
			salary, vehicleAndTransport, household,
			shopping, phone, entertainment,
			medicine, investment, tax,
			insurance, foodAndDrinks,
			misc, transfer, lend,
			borrow
		]
	}

}
