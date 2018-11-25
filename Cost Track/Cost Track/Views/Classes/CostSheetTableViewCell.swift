//
//  CostSheetTableViewCell.swift
//  Cost Track
//
//  Created by Karthik M S on 14/07/18.
//  Copyright © 2018 Karthik M S. All rights reserved.
//

import UIKit

class CostSheetTableViewCell: UITableViewCell {

	// MARK: IBOutlets
	@IBOutlet weak var costSheetNameLabel: UILabel!
	@IBOutlet weak var balanceAmountLabel: UILabel!
	@IBOutlet weak var dateLabel: UILabel!
	@IBOutlet weak var incomeAmountLabel: UILabel!
	@IBOutlet weak var expenseAmountLabel: UILabel!
	@IBOutlet weak var incomeCountLabel: UILabel!
	@IBOutlet weak var expenseCountLabel: UILabel!

	// MARK: Functions
	func setValues(for costSheet: CostSheet) {
		costSheetNameLabel.text = costSheet.name
		dateLabel.text = costSheet.lastModifiedDateString

		// Balance label
		var balance = costSheet.balanceInAccountingPeriod
		if balance < 0 {
			balanceAmountLabel.textColor = DarkExpenseColor
			balance *= -1
		} else {
			balanceAmountLabel.textColor = DarkIncomeColor
		}
		balanceAmountLabel.text = String(balance)

		let incomeExpenseInfo = costSheet.incomeExpenseInfo
		incomeCountLabel.text = String(incomeExpenseInfo.incomeCount)
		expenseCountLabel.text = String(incomeExpenseInfo.expenseCount)
		incomeAmountLabel.text = String(incomeExpenseInfo.incomeAmount)
		expenseAmountLabel.text = String(incomeExpenseInfo.expenseAmount)
	}
}
