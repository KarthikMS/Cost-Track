//
//  CostSheetViewController.swift
//  Cost Track
//
//  Created by Karthik M S on 15/07/18.
//  Copyright © 2018 Karthik M S. All rights reserved.
//

import UIKit

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
	var costSheet = CostSheet()
	var classificationMode = TransactionClassificationMode.date
	var sortedEntries = [
		Int: [
			String: [CostSheetEntry]
		]
		]()

	// MARK: UIViewController functions
    override func viewDidLoad() {
        super.viewDidLoad()

		// Amount label
		var balance = costSheet.balance
		if balance < 0 {
			amountLabel.textColor = ExpenseColor
			balance *= -1
		} else {
			amountLabel.textColor = IncomeColor
		}
		amountLabel.text = String(balance)

		sortEntries()
		transactionsTableViewDataSource.dataSource = self
		transactionsTableView.register(UINib(nibName: "TransactionsTableViewCell", bundle: nil), forCellReuseIdentifier: "TransactionsTableViewCell")
		transactionsTableView.dataSource = transactionsTableViewDataSource
    }

	// MARK: Navigation
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "CostSheetEntrySegue" {
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

	// MARK: Misc.
	private func sortEntries() {
		sortedEntries.removeAll()
		switch classificationMode {
		case .date:
			sortEntriesBasedOnDate()
		default:
			return
		}
	}

	private func sortEntriesBasedOnDate() {
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
			if sortedEntries.isEmpty {
				sortedEntries[0] = [dateString: [entry]]
			} else {
				let lastSortedEntryIndex = sortedEntries.count - 1
				guard let lastSortedEntry = sortedEntries[lastSortedEntryIndex],
					let sortedDateString = lastSortedEntry.keys.first else {
						assertionFailure()
						return
				}
				if sortedDateString == dateString {
					var arr = lastSortedEntry[sortedDateString]
					arr?.append(entry)
					sortedEntries[lastSortedEntryIndex]![sortedDateString] = arr
				} else {
					sortedEntries[lastSortedEntryIndex + 1] = [dateString: [entry]]
				}
			}
		}
	}

	func getSortedEntry(at indexPath: IndexPath) -> CostSheetEntry? {
		guard let entries = sortedEntries[indexPath.section] else {
			assertionFailure()
			return nil
		}
		return Array(entries)[0].value[indexPath.row]
	}

}

// MARK: IBActions
extension CostSheetViewController {

	@IBAction func expenseButtonPressed(_ sender: Any) {
		performSegue(withIdentifier: "CostSheetEntrySegue", sender: ["entryType": CostSheetEntry.EntryType.expense])
	}

	@IBAction func incomeButtonPressed(_ sender: Any) {
		performSegue(withIdentifier: "CostSheetEntrySegue", sender: ["entryType": CostSheetEntry.EntryType.income])
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
		performSegue(withIdentifier: "CostSheetEntrySegue", sender: ["oldEntry": costSheetEntry])
	}

}

// TODO: Delete once saving protos has been added
// MARK: CostSheetEntryDelegate
extension CostSheetViewController: CostSheetEntryDelegate {

	func entryAdded(_ entry: CostSheetEntry) {
		costSheet.entries.append(entry)
		sortEntries()
		transactionsTableView.reloadData()
	}

}
