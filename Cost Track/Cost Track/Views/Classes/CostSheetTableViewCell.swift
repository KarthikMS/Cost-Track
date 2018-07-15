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
	func setCostSheetName(_ costSheetName: String, balanceAmount: Float, date: String, income: Float, expense: Float, incomeCount: Int, expenseCount: Int) {
		costSheetNameLabel.text = costSheetName
		balanceAmountLabel.text = String(balanceAmount)
		dateLabel.text = date
		incomeAmountLabel.text = String(income)
		expenseAmountLabel.text = String(expense)
		incomeCountLabel.text = String(incomeCount)
		expenseCountLabel.text = String(expenseCount)
	}
}
