//
//  MyCostSheetsViewController.swift
//  Cost Track
//
//  Created by Karthik M S on 14/07/18.
//  Copyright © 2018 Karthik M S. All rights reserved.
//

import UIKit

class MyCostSheetsViewController: UIViewController {

	// MARK: IBOutlets
	@IBOutlet weak var totalAmountLabel: UILabel!
	@IBOutlet weak var tableView: UITableView!

	// MARK: Properties
	var account = Account()

	// MARK: UIViewController functions
    override func viewDidLoad() {
        super.viewDidLoad()

		// Test
		var costSheetEntry1 = CostSheetEntry()
		costSheetEntry1.amount = 500
		costSheetEntry1.category = .misc
		costSheetEntry1.type = .income
		costSheetEntry1.date = NSKeyedArchiver.archivedData(withRootObject: Date())
		costSheetEntry1.id = UUID().uuidString

		var costSheet = CostSheet()
		costSheet.id = UUID().uuidString
		costSheet.initialBalance = 0
		costSheet.name = "Hardcoded"
		costSheet.entries.append(costSheetEntry1)
		account.costSheets.append(costSheet)
		// Test

		tableView.register(UINib(nibName: "CostSheetTableViewCell", bundle: nil), forCellReuseIdentifier: "CostSheetTableViewCell")
	}

	// MARK: Navigation
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		guard let identifier = segue.identifier else {
			return
		}
		if identifier == CostSheetSegue {
			guard let sender = sender as? [String: CostSheet],
				let costSheet = sender["costSheet"],
				let costSheetViewController = segue.destination as? CostSheetViewController else {
					return
			}
			costSheetViewController.costSheet = costSheet
		} else if identifier == NewCostSheetSegue {
			guard let newCostSheetViewController = segue.destination as? NewCostSheetViewController else {
				return
			}
			newCostSheetViewController.dataSource = self
			newCostSheetViewController.delegate = self
		}
	}

	// MARK: Misc. functions
	private func costSheetAtIndexPath(_ indexPath: IndexPath) -> CostSheet {
		var index = indexPath.row
		for i in 0..<indexPath.section {
			index += account.numberOfCostSheetsInGroup(account.groups[i])
		}
		return account.costSheets[index]
	}
}

// MARK: IBActions
extension MyCostSheetsViewController {

	@IBAction func chartViewButtonPressed(_ sender: Any) {
		// Finish this
	}

	@IBAction func generalStatisticsButtonPressed(_ sender: Any) {
		// Finish this
	}

	@IBAction func addNewCostSheetButtonPressed(_ sender: Any) {
		// Finish this
	}

	@IBAction func settingsButtonPressed(_ sender: Any) {
		// Finish this
	}

	@IBAction func searchButtonPressed(_ sender: Any) {
		// Finish this
	}

}

// MARK: UITableViewDataSource
extension MyCostSheetsViewController: UITableViewDataSource {

	func numberOfSections(in tableView: UITableView) -> Int {
		// Finish this
		return 1
	}

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		// Finish this
		return account.costSheets.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "CostSheetTableViewCell", for: indexPath) as! CostSheetTableViewCell
		let costSheet = costSheetAtIndexPath(indexPath)

		cell.costSheetNameLabel.text = costSheet.name
		cell.dateLabel.text = costSheet.lastModifiedDate

		// Balance label
		var balance = costSheet.balance
		if balance < 0 {
			cell.balanceAmountLabel.textColor = ExpenseColor
			balance *= -1
		} else {
			cell.balanceAmountLabel.textColor = IncomeColor
		}
		cell.balanceAmountLabel.text = String(balance)

		let incomeExpenseInfo = costSheet.incomeExpenseInfo
		cell.incomeCountLabel.text = String(incomeExpenseInfo.incomeCount)
		cell.expenseCountLabel.text = String(incomeExpenseInfo.expenseCount)
		cell.incomeAmountLabel.text = String(incomeExpenseInfo.incomeAmount)
		cell.expenseAmountLabel.text = String(incomeExpenseInfo.expenseAmount)

		return cell
	}

}

// MARK: UITableViewDelegate
extension MyCostSheetsViewController: UITableViewDelegate {

	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 80
	}

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let costSheet = costSheetAtIndexPath(indexPath)
		tableView.deselectRow(at: indexPath, animated: true)
		performSegue(withIdentifier: "CostSheetSegue", sender: ["costSheet": costSheet])
	}

}

// MARK: NewCostSheetDataSource
extension MyCostSheetsViewController: NewCostSheetDataSource {

	var defaultCostSheetName: String {
		return account.defaultNewCostSheetName
	}

}

// MARK: NewCostSheetDelegate
extension MyCostSheetsViewController: NewCostSheetDelegate {

	func didCreateCostSheet(_ costSheet: CostSheet) {
		account.costSheets.append(costSheet)
		tableView.reloadData()
	}

}
