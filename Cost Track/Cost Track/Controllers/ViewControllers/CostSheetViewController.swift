//
//  CostSheetViewController.swift
//  Cost Track
//
//  Created by Karthik M S on 15/07/18.
//  Copyright © 2018 Karthik M S. All rights reserved.
//

import UIKit

protocol CostSheetViewControllerProtocol {
	func didUpdateCostSheet(withId id: String, with updatedCostSheet: CostSheet)
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

	// MARK: Properties
	let transactionsTableViewDataSource = TransactionsTableViewDataSource()
	var delegate: CostSheetViewControllerProtocol?
	var costSheet = CostSheet()
	var classificationMode = TransactionClassificationMode.date
	var sortedEntriesForTableView = [
		Int: [
			String: [CostSheetEntry]
		]
		]()
	private var entriesSortedByDate = [CostSheetEntry]()
	private let categories = CommonUtil.getAllCategories()

	// MARK: UIViewController functions
    override func viewDidLoad() {
        super.viewDidLoad()

		sortEntries()
		transactionsTableViewDataSource.dataSource = self
		transactionsTableView.register(UINib(nibName: "TransactionsTableViewCell", bundle: nil), forCellReuseIdentifier: "TransactionsTableViewCell")
		transactionsTableView.dataSource = transactionsTableViewDataSource
    }

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)

		updateAmountLabel()
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

	@IBAction func expenseButtonPressed(_ sender: Any) {
		performSegue(withIdentifier: CostSheetEntrySegue, sender: ["entryType": CostSheetEntry.EntryType.expense])
	}

	@IBAction func incomeButtonPressed(_ sender: Any) {
		performSegue(withIdentifier: CostSheetEntrySegue, sender: ["entryType": CostSheetEntry.EntryType.income])
	}

	@IBAction func classificationSegmentedControlValueChanged(_ sender: UISegmentedControl) {
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

}

// MARK: CostSheetEntryDelegate
extension CostSheetViewController: CostSheetEntryViewControllerDelegate {

	func didAddEntry(_ entry: CostSheetEntry) {
		costSheet.entries.append(entry)
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
