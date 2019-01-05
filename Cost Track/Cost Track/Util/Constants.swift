//
//  Constants.swift
//  Cost Track
//
//  Created by Karthik M S on 29/07/18.
//  Copyright © 2018 Karthik M S. All rights reserved.
//

import UIKit

var NotSetGroup = CostSheetGroup()
var TransferCategory = Category()

// MARK: Colors
let DarkIncomeColor = UIColor(red: 0/255.0, green: 128/255.0, blue: 0/255.0, alpha: 1)
let DarkExpenseColor = UIColor(red: 255/255.0, green: 8/255.0, blue: 41/255.0, alpha: 1)
let LightIncomeColor = UIColor(red: 102/255.0, green: 255/255.0, blue: 102/255.0, alpha: 1)
let LightExpenseColor = UIColor(red: 255/255.0, green: 102/255.0, blue: 102/255.0, alpha: 1)
let TintedWhiteColor = UIColor(red: 247/255.0, green: 247/255.0, blue: 247/255.0, alpha: 1.0)

// MARK: Segue Identifiers
// Main Storyboard
let	CostSheetSegue = "CostSheetSegue"
let CostSheetEntrySegue = "CostSheetEntrySegue"
let NewCostSheetSegue = "NewCostSheetSegue"
let SettingsSegue = "SettingsSegue"
let TransferEntrySegue = "TransferEntrySegue"
let ViewPhotoSegue = "ViewPhotoSegue"
let GroupSelectSegue = "GroupSelectSegue"
let TransferAmountSegue = "TransferAmountSegue"
let CostSheetSettingsSegue = "CostSheetSettingsSegue"
let GroupSelectFromCostSheetSettingsSegue = "GroupSelectFromCostSheetSettingsSegue"
let SelectPlaceSegue = "SelectPlaceSegue"

// Settings Storyboard
let AllPlacesSegue = "AllPlacesSegue"

// MARK: Strings
let BalanceCarryOver = "BalanceCarryOver"
let StartDayForMonthlyAccountingPeriod = "StartDayForMonthlyAccountingPeriod"
let AccountingPeriodFormat = "AccountingPeriodFormat"
