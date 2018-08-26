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
	private var sectionsToHide = Set<Int>()

	// MARK: UIViewController functions
    override func viewDidLoad() {
        super.viewDidLoad()

		// Setting NotSetGroup. Should happen only once in app's life time.
		if account.groups.isEmpty {
			var notSetGroup = CostSheetGroup()
			notSetGroup.name = "Not set"
			notSetGroup.id = UUID().uuidString
			account.groups.append(notSetGroup)

			NotSetGroup = notSetGroup
		}

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
			sectionsToHide.removeAll()
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
		let groupsWithCostSheets = account.groupsWithCostSheets
		return account.costSheetsInGroup(groupsWithCostSheets[indexPath.section])[indexPath.row]
	}

	private func showAlertForDeletingCostSheet(withId id: String, at indexPath: IndexPath) {
		let alertController = UIAlertController(title: nil, message: "The specified list is not empty. Are you sure you want to delete it?", preferredStyle: .alert)
		alertController.addAction(UIAlertAction(
			title: "Cancel", style: .cancel, handler: { (action) in
				alertController.dismiss(animated: true)
		}))
		alertController.addAction(UIAlertAction(
			title: "Delete", style: .destructive, handler: { (action) in
				self.deleteCostSheet(withId: id, at: indexPath)
				alertController.dismiss(animated: true)
		}))
		present(alertController, animated: true)
	}

	private func deleteCostSheet(withId id: String, at indexPath: IndexPath) {
		account.deleteCostSheet(withId: id)
		if !account.hasCostSheetsInOtherGroups {
			sectionsToHide.removeAll()
			tableView.reloadData()
		} else {
			tableView.beginUpdates()
			if tableView.numberOfRows(inSection: indexPath.section) == 1 {
				tableView.deleteSections([indexPath.section], with: .bottom)
			} else {
				tableView.deleteRows(at: [indexPath], with: .left)
			}
			tableView.endUpdates()
		}
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
		return account.groupsWithCostSheets.count
	}

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if sectionsToHide.contains(section) {
			return 0
		}
		let groupsWithCostSheets = account.groupsWithCostSheets
		return account.costSheetsInGroup(groupsWithCostSheets[section]).count
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
			if costSheet.entries.isEmpty {
				self.deleteCostSheet(withId: costSheet.id, at: indexPath)
			} else {
				self.showAlertForDeletingCostSheet(withId: costSheet.id, at: indexPath)
			}
		}
		return [deleteCostSheetAction]
	}

	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		if !account.hasCostSheetsInOtherGroups {
			return 0
		}
		return 40
	}

	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		if !account.hasCostSheetsInOtherGroups {
			return nil
		}

		var frame = tableView.frame
		frame.origin.y = 0
		frame.size.height = 40
		let title = account.groupsWithCostSheets[section].name
		let headerView = TableViewSectionHeaderView(frame: frame, section: section, text: title, delegate: self)
		return headerView
	}

}

// MARK: TableViewSectionHeaderViewDelegate
extension MyCostSheetsViewController: TableViewSectionHeaderViewDelegate {

	func sectionHeaderViewTapped(section: Int) {
		if sectionsToHide.contains(section) {
			sectionsToHide.remove(section)
		} else {
			sectionsToHide.insert(section)
		}
		tableView.reloadData()
	}

}

// MARK: NewCostSheetDataSource
extension MyCostSheetsViewController: NewCostSheetViewControllerDataSource {

	var defaultCostSheetName: String {
		return account.defaultNewCostSheetName
	}

	func getGroup(withId id: String) -> CostSheetGroup {
		guard let group = account.getGroup(withId: id) else {
			assertionFailure()
			return CostSheetGroup()
		}
		return group
	}

}

// MARK: GroupSelectTableViewControllerDataSource
extension MyCostSheetsViewController: GroupSelectTableViewControllerDataSource {

	var groups: [CostSheetGroup] {
		return account.groups
	}

	func numberOfCostSheets(in group: CostSheetGroup) -> Int {
		return account.costSheetsInGroup(group).count
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

	func didCreateGroup(withName name: String) {
		var newGroup = CostSheetGroup()
		newGroup.name = name
		newGroup.id = UUID().uuidString
		account.groups.append(newGroup)
	}

	func didDeleteGroup(at index: Int) {
		account.moveCostSheets(from: account.groups[index], to: NotSetGroup)
		account.groups.remove(at: index)
		shouldUpdateViews = true
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
