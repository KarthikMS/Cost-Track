//
//  CostSheetViewController.swift
//  Cost Track
//
//  Created by Karthik M S on 15/07/18.
//  Copyright © 2018 Karthik M S. All rights reserved.
//

import UIKit

protocol CostSheetViewControllerDelegate {
	func didUpdateCostSheet(withId id: String, with updatedCostSheet: CostSheet)
	func didDeleteCostSheetEntry(withId entryId: String, inCostSheetWithId costSheetId: String)
	func didTransferCostSheetEntry(_ costSheetEntry: CostSheetEntry, to toCostSheet: CostSheet)
}

enum TransactionClassificationMode {
	case date
	case category
	case place
}

class CostSheetViewController: UIViewController {

	// MARK: IBOutlets
	@IBOutlet weak var amountLabel: UILabel!
	@IBOutlet weak var transactionsTableView: UITableView!
	@IBOutlet weak var noEntriesTextView: UITextView!
	
	// MARK: Properties
	weak var myCostSheetsViewController = MyCostSheetsViewController()
	let transactionsTableViewDataSource = TransactionsTableViewDataSource()
	var delegate: CostSheetViewControllerDelegate?
	var costSheet = CostSheet()
	var classificationMode = TransactionClassificationMode.date
	var sortedEntriesForTableView = [
		Int: [
			String: [CostSheetEntry]
		]
		]()
	private var entriesSortedByDate = [CostSheetEntry]()
	private let categories = CommonUtil.getAllCategories()
	private var transferIndexPath: IndexPath?

	// MARK: UIViewController functions
    override func viewDidLoad() {
        super.viewDidLoad()

		navigationItem.title = costSheet.name

		if costSheet.entries.isEmpty {
			transactionsTableView.isHidden = true
		} else {
			noEntriesTextView.isHidden = true
			sortEntries()
		}

		transactionsTableViewDataSource.dataSource = self
		transactionsTableView.register(UINib(nibName: "TransactionsTableViewCell", bundle: nil), forCellReuseIdentifier: "TransactionsTableViewCell")
		transactionsTableView.dataSource = transactionsTableViewDataSource
    }

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)

		updateAmountLabel()
		transferIndexPath = nil
	}

	// MARK: Navigation
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == CostSheetEntrySegue {
			guard let costSheetEntryViewController = segue.destination as? CostSheetEntryViewController,
			let sender = sender as? [String: Any] else {
					assertionFailure()
					return
			}
			costSheetEntryViewController.delegate = self
			if let oldEntry = sender["oldEntry"] as? CostSheetEntry {
				costSheetEntryViewController.oldEntry = oldEntry
			} else {
				guard let entryType = sender["entryType"] as? CostSheetEntry.EntryType else {
					assertionFailure()
					return
				}
				costSheetEntryViewController.entryType = entryType
			}
		} else if segue.identifier == TransferEntrySegue {
			guard let transferEntryTableViewController = (segue.destination as? UINavigationController)?.topViewController as? TransferEntryTableViewController else {
				assertionFailure()
				return
			}
			transferEntryTableViewController.dataSource = myCostSheetsViewController
			transferEntryTableViewController.delegate = self
		}
	}

	// MARK: View functions
	private func updateAmountLabel() {
		var balance = costSheet.balance
		if balance < 0 {
			amountLabel.backgroundColor = DarkExpenseColor
			balance *= -1
		} else {
			amountLabel.backgroundColor = DarkIncomeColor
		}
		amountLabel.text = String(balance)
	}

	// MARK: Sorting functions
	private func sortEntries() {
		sortedEntriesForTableView.removeAll()
		switch classificationMode {
		case .date:
			sortEntriesByDate()
		case .category:
			sortEntriesByCategory()
		case .place:
			sortEntriesByPlace()
		}
	}

	private func sortEntriesByDate() {
		let entries = costSheet.entries.sorted(by: { (entry1, entry2) -> Bool in
			guard let date1 = entry1.date.date,
				let date2 = entry2.date.date else {
					assertionFailure()
					return false
			}
			return date1 > date2
		})
		for entry in entries {
			guard let dateString = entry.date.date?.string(format: "dd MMMM yyyy, EEE") else {
				assertionFailure()
				return
			}
			if sortedEntriesForTableView.isEmpty {
				sortedEntriesForTableView[0] = [dateString: [entry]]
			} else {
				let lastSortedEntryIndex = sortedEntriesForTableView.count - 1
				guard let lastSortedEntry = sortedEntriesForTableView[lastSortedEntryIndex],
					let sortedDateString = lastSortedEntry.keys.first else {
						assertionFailure()
						return
				}
				if sortedDateString == dateString {
					var arr = lastSortedEntry[sortedDateString]
					arr?.append(entry)
					sortedEntriesForTableView[lastSortedEntryIndex]![sortedDateString] = arr
				} else {
					sortedEntriesForTableView[lastSortedEntryIndex + 1] = [dateString: [entry]]
				}
			}
		}

		// entriesSortedByDate
		let tempSortedEntries = sortedEntriesForTableView.sorted(by: { $0.key > $1.key })
		entriesSortedByDate.removeAll()
		for (_, value) in tempSortedEntries {
			for (_, entries) in value {
				entriesSortedByDate.append(contentsOf: entries)
			}
		}
	}

	private func sortEntriesByCategory() {
		var entriesSortedByCategory = [CostSheetEntry.Category: [CostSheetEntry]]()
		for category in categories {
			entriesSortedByCategory[category] = [CostSheetEntry]()
		}

		for entry in entriesSortedByDate {
			entriesSortedByCategory[entry.category]?.append(entry)
		}

		var i = 0
		for (category, entries) in entriesSortedByCategory {
			if entries.count == 0 {
				continue
			}

			let dict = [category.name: entries]
			sortedEntriesForTableView[i] = dict
			i += 1
		}
	}

	private func sortEntriesByPlace() {

	}

	func getSortedEntry(at indexPath: IndexPath) -> CostSheetEntry? {
		guard let entries = sortedEntriesForTableView[indexPath.section] else {
			assertionFailure()
			return nil
		}
		return Array(entries)[0].value[indexPath.row]
	}

}

// MARK: IBActions
extension CostSheetViewController {

	@IBAction private func expenseButtonPressed(_ sender: Any) {
		performSegue(withIdentifier: CostSheetEntrySegue, sender: ["entryType": CostSheetEntry.EntryType.expense])
	}

	@IBAction private func incomeButtonPressed(_ sender: Any) {
		performSegue(withIdentifier: CostSheetEntrySegue, sender: ["entryType": CostSheetEntry.EntryType.income])
	}

	@IBAction private func classificationSegmentedControlValueChanged(_ sender: UISegmentedControl) {
		switch sender.selectedSegmentIndex {
		case 0:
			classificationMode = .date

		case 1:
			classificationMode = .category
		default:
			classificationMode = .place
		}
		sortEntries()
		transactionsTableView.reloadData()
	}

}

// MARK: UITableViewDelegate
extension CostSheetViewController: UITableViewDelegate {

	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 80
	}

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		guard let costSheetEntry = getSortedEntry(at: indexPath) else {
			assertionFailure()
			return
		}
		tableView.deselectRow(at: indexPath, animated: true)
		performSegue(withIdentifier: CostSheetEntrySegue, sender: ["oldEntry": costSheetEntry])
	}

	func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
		let transferEntryAction = UITableViewRowAction(style: .normal, title: "Transfer") { (action, indexPath) in
			// Checking cost sheets count
			if self.myCostSheetsViewController?.account.costSheets.count == 1 {
				// Show alert
				return
			}

			self.transferIndexPath = indexPath
			self.performSegue(withIdentifier: TransferEntrySegue, sender: nil)
		}
		transferEntryAction.backgroundColor = .darkGray
		let deleteEntryAction = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
			guard let entryToDelete = self.getSortedEntry(at: indexPath) else {
				assertionFailure()
				return
			}

			self.costSheet.deleteEntry(withId: entryToDelete.id)
			if self.classificationMode != .date {
				self.sortEntriesByDate()
			}
			self.sortEntries()
			self.costSheet.entries = self.entriesSortedByDate
			tableView.beginUpdates()
			if tableView.numberOfRows(inSection: indexPath.section) == 1 {
				tableView.deleteSections([indexPath.section], with: .bottom)
			} else {
				tableView.deleteRows(at: [indexPath], with: .left)
			}
			tableView.endUpdates()

			self.updateAmountLabel()
			self.delegate?.didDeleteCostSheetEntry(withId: entryToDelete.id, inCostSheetWithId: self.costSheet.id)
		}
		return [deleteEntryAction, transferEntryAction]
	}

}

// MARK: CostSheetEntryViewControllerDelegate
extension CostSheetViewController: CostSheetEntryViewControllerDelegate {

	func didAddEntry(_ entry: CostSheetEntry) {
		costSheet.entries.append(entry)
		noEntriesTextView.isHidden = true
		transactionsTableView.isHidden = false
		reloadAfterEntryModification()
	}

	func didUpdateEntry(withId id: String, with updatedEntry: CostSheetEntry) {
		costSheet.updateEntry(withId: id, with: updatedEntry)
		reloadAfterEntryModification()
	}

	private func reloadAfterEntryModification() {
		if classificationMode != .date {
			sortEntriesByDate()
		}
		sortEntries()
		transactionsTableView.reloadData()
		costSheet.entries = entriesSortedByDate
		delegate?.didUpdateCostSheet(withId: costSheet.id, with: costSheet)
	}

}

// MARK: TransferEntryTableViewControllerDelegate
extension CostSheetViewController: TransferEntryTableViewControllerDelegate {

	func didTransferCostSheetEntryToCostSheet(_ toCostSheet: CostSheet) {
		guard let transferIndexPath = transferIndexPath,
			let entryToTransfer = getSortedEntry(at: transferIndexPath) else {
				assertionFailure("transferIndexPath not set")
				return
		}
		costSheet.deleteEntry(withId: entryToTransfer.id)
		if classificationMode != .date {
			sortEntriesByDate()
		}
		sortEntries()
		costSheet.entries = entriesSortedByDate
		transactionsTableView.beginUpdates()
		if transactionsTableView.numberOfRows(inSection: transferIndexPath.section) == 1 {
			transactionsTableView.deleteSections([transferIndexPath.section], with: .bottom)
		} else {
			transactionsTableView.deleteRows(at: [transferIndexPath], with: .left)
		}
		transactionsTableView.endUpdates()

		updateAmountLabel()
		delegate?.didTransferCostSheetEntry(entryToTransfer, to: toCostSheet)
	}

}
