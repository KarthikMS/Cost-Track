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
		salary.canEdit = true
		salary.id = UUID().uuidString

		var vehicleAndTransport = Category()
		vehicleAndTransport.name = "Vehicle & Transport"
		vehicleAndTransport.iconType = .vehicleAndTransport
		vehicleAndTransport.entryTypes.append(EntryType.expense)
		vehicleAndTransport.canEdit = true
		vehicleAndTransport.id = UUID().uuidString

		var household = Category()
		household.name = "Household"
		household.iconType = .household
		household.entryTypes.append(contentsOf: [EntryType.income, EntryType.expense])
		household.canEdit = true
		household.id = UUID().uuidString

		var shopping = Category()
		shopping.name = "Shopping"
		shopping.iconType = .shopping
		shopping.entryTypes.append(EntryType.expense)
		shopping.canEdit = true
		shopping.id = UUID().uuidString

		var phone = Category()
		phone.name = "Phone"
		phone.iconType = .phone
		phone.entryTypes.append(EntryType.expense)
		phone.canEdit = true
		phone.id = UUID().uuidString

		var entertainment = Category()
		entertainment.name = "Entertainment"
		entertainment.iconType = .entertainment
		entertainment.entryTypes.append(contentsOf: [EntryType.income, EntryType.expense])
		entertainment.canEdit = true
		entertainment.id = UUID().uuidString

		var medicine = Category()
		medicine.name = "Medicine"
		medicine.iconType = .medicine
		medicine.entryTypes.append(EntryType.expense)
		medicine.canEdit = true
		medicine.id = UUID().uuidString

		var investment = Category()
		investment.name = "Investment"
		investment.iconType = .investment
		investment.entryTypes.append(contentsOf: [EntryType.income, EntryType.expense])
		investment.canEdit = true
		investment.id = UUID().uuidString

		var tax = Category()
		tax.name = "Tax"
		tax.iconType = .tax
		tax.entryTypes.append(EntryType.expense)
		tax.canEdit = true
		tax.id = UUID().uuidString

		var insurance = Category()
		insurance.name = "Insurance"
		insurance.iconType = .insurance
		insurance.entryTypes.append(contentsOf: [EntryType.income, EntryType.expense])
		insurance.canEdit = true
		insurance.id = UUID().uuidString

		var foodAndDrinks = Category()
		foodAndDrinks.name = "Food & Drinks"
		foodAndDrinks.iconType = .foodAndDrinks
		foodAndDrinks.entryTypes.append(EntryType.expense)
		foodAndDrinks.canEdit = true
		foodAndDrinks.id = UUID().uuidString

		var misc = Category()
		misc.name = "Misc"
		misc.iconType = .misc
		misc.entryTypes.append(contentsOf: [EntryType.income, EntryType.expense])
		misc.canEdit = true
		misc.id = UUID().uuidString

		var transfer = Category()
		transfer.name = "Transfer"
		transfer.iconType = .transfer
		transfer.entryTypes.append(contentsOf: [EntryType.income, EntryType.expense])
		transfer.canEdit = true
		transfer.id = UUID().uuidString

		TransferCategory = transfer

		var lend = Category()
		lend.name = "Lend"
		lend.iconType = .lend
		lend.entryTypes.append(contentsOf: [EntryType.income, EntryType.expense])
		lend.canEdit = false
		lend.id = UUID().uuidString

		var borrow = Category()
		borrow.name = "Borrow"
		borrow.iconType = .borrow
		borrow.entryTypes.append(contentsOf: [EntryType.income, EntryType.expense])
		borrow.canEdit = false
		borrow.id = UUID().uuidString

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
