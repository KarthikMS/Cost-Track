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
	@IBOutlet weak var topBar: UIView!
	@IBOutlet weak var totalAmountLabel: UILabel!
	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var noCostSheetsTextView: UITextView!

	// MARK: Properties
	var account = Account()
	var selectedCostSheetId: String?
	private var shouldUpdateViews = false

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
		costSheet.lastModifiedDate = Date().data
		costSheet.entries.append(costSheetEntry1)
//		account.costSheets.append(costSheet)
		// Test

		if account.costSheets.isEmpty {
			tableView.isHidden = true
		} else {
			noCostSheetsTextView.isHidden = true
		}
		tableView.register(UINib(nibName: "CostSheetTableViewCell", bundle: nil), forCellReuseIdentifier: "CostSheetTableViewCell")
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)

		if shouldUpdateViews {
			updateTopBar()
			tableView.reloadData()
			shouldUpdateViews = false
		}

		selectedCostSheetId = nil
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
			costSheetViewController.delegate = self
			costSheetViewController.myCostSheetsViewController = self
		} else if identifier == NewCostSheetSegue {
			guard let newCostSheetViewController = segue.destination as? NewCostSheetViewController else {
				return
			}
			newCostSheetViewController.dataSource = self
			newCostSheetViewController.delegate = self
		}
	}

	// MARK: View functions
	private func updateTopBar() {
		var totalAmount = account.totalAmount
		if totalAmount < 0 {
			topBar.backgroundColor = DarkExpenseColor
			totalAmount *= -1
		} else {
			topBar.backgroundColor = DarkIncomeColor
		}
		totalAmountLabel.text = String(totalAmount)
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

	@IBAction private func chartViewButtonPressed(_ sender: Any) {
		// Finish this
	}

	@IBAction private func generalStatisticsButtonPressed(_ sender: Any) {
		// Finish this
	}

	@IBAction private func addNewCostSheetButtonPressed(_ sender: Any) {
		// Finish this
	}

	@IBAction private func settingsButtonPressed(_ sender: Any) {
		// Finish this
	}

	@IBAction private func searchButtonPressed(_ sender: Any) {
		// Finish this
	}

}

// MARK: UITableViewDataSource
extension MyCostSheetsViewController: UITableViewDataSource {

	func numberOfSections(in tableView: UITableView) -> Int {
		var numberOfSections = 0
		for group in account.groups {
			if account.numberOfCostSheetsInGroup(group) > 0 {
				numberOfSections += 1
			}
		}
		for costSheet in account.costSheets where costSheet.hasGroup == false {
			numberOfSections += 1
		}
		return numberOfSections
	}

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		// Finish this
		return account.costSheets.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "CostSheetTableViewCell", for: indexPath) as! CostSheetTableViewCell
		cell.setValuesForCostSheet(costSheetAtIndexPath(indexPath))
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
		selectedCostSheetId = costSheet.id
		tableView.deselectRow(at: indexPath, animated: true)
		performSegue(withIdentifier: "CostSheetSegue", sender: ["costSheet": costSheet])
	}

	func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
		let deleteCostSheetAction = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
			let costSheet = self.costSheetAtIndexPath(indexPath)
			guard costSheet.entries.isEmpty else {
				// Show dialog box
				return
			}

			self.account.deleteCostSheet(withId: costSheet.id)
			tableView.beginUpdates()
			if tableView.numberOfRows(inSection: indexPath.section) == 1 {
				tableView.deleteSections([indexPath.section], with: .bottom)
			} else {
				tableView.deleteRows(at: [indexPath], with: .left)
			}
			tableView.endUpdates()
		}
		return [deleteCostSheetAction]
	}

}

// MARK: NewCostSheetDataSource
extension MyCostSheetsViewController: NewCostSheetViewControllerDataSource {

	var defaultCostSheetName: String {
		return account.defaultNewCostSheetName
	}

}

// MARK: NewCostSheetDelegate
extension MyCostSheetsViewController: NewCostSheetViewControllerDelegate {

	func didCreateCostSheet(_ costSheet: CostSheet) {
		account.costSheets.append(costSheet)
		noCostSheetsTextView.isHidden = true
		tableView.isHidden = false
		tableView.reloadData()
	}

}

// MARK: CostSheetViewControllerDelegate
extension MyCostSheetsViewController: CostSheetViewControllerDelegate {

	func didUpdateCostSheet(withId id: String, with updatedCostSheet: CostSheet) {
		account.updateCostSheet(withId: id, with: updatedCostSheet)
		shouldUpdateViews = true
	}

	func didDeleteCostSheetEntry(withId entryId: String, inCostSheetWithId costSheetId: String) {
		account.deleteCostSheetEntry(withId: entryId, inCostSheetWithId: costSheetId)
		shouldUpdateViews = true
	}

	func didTransferCostSheetEntry(_ costSheetEntry: CostSheetEntry, to toCostSheet: CostSheet) {
		guard let selectedCostSheetId = selectedCostSheetId else {
			assertionFailure()
			return
		}
		var numberOfTasks = 2
		for i in 0..<account.costSheets.count {
			if account.costSheets[i].id == selectedCostSheetId {
				account.costSheets[i].deleteEntry(withId: costSheetEntry.id)
				if numberOfTasks == 1 {
					break
				}
				numberOfTasks -= 1
			} else if account.costSheets[i].id == toCostSheet.id {
				account.costSheets[i].entries.append(costSheetEntry)
				if numberOfTasks == 1 {
					break
				}
				numberOfTasks -= 1
			}
		}

		shouldUpdateViews = true
	}

}

// MARK: TransferEntryTableViewControllerDataSource
extension MyCostSheetsViewController: TransferEntryTableViewControllerDataSource {

	var filteredCostSheets: [CostSheet] {
		guard let selectedCostSheetId = selectedCostSheetId else {
			assertionFailure()
			return []
		}
		var costSheets = [CostSheet]()
		for costSheet in account.costSheets {
			if costSheet.id != selectedCostSheetId {
				costSheets.append(costSheet)
			}
		}
		return costSheets
	}

}
