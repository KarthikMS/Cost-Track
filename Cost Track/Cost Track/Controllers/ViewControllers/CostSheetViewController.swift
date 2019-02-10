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
	@IBOutlet weak var noEntriesTextView: UITextView!
	@IBOutlet weak var costSheetNameLabel: UILabel!
	@IBOutlet weak var accountingPeriodLabel: UILabel!
	
	// MARK: Properties
	weak var documentHandler: DocumentHandler!
	private var costSheetId: String!
	func setup(documentHandler: DocumentHandler, costSheetId: String) {
		self.documentHandler = documentHandler
		self.costSheetId = costSheetId
	}

	let transactionsTableViewDataSource = TransactionsTableViewDataSource()
	var classificationMode = TransactionClassificationMode.date
	var sortedEntriesForTableView = [
		Int: [
			String: [CostSheetEntry]
		]
		]() // [section: [sectionHeaderTitle: [CostSheetEntry]]]
	private var entriesSortedByDate = [CostSheetEntry]()
	private var transferEntryIndexPath: IndexPath?
	var sectionsToHide = Set<Int>()
	private var isLoadingViewsForFirstTime = true

	// MARK: UIViewController functions
    override func viewDidLoad() {
        super.viewDidLoad()

		setUpTableView()
    }

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)

		guard let costSheet = documentHandler.getDocument().costSheetWithId(costSheetId) else {
			assertionFailure("Could not get costSheet")
			return
		}

		updateNavigationBar(for: costSheet)
		updateAmountLabel()
		if classificationMode != .date {
			sortedEntriesForTableView.removeAll()
			sortEntriesByDate()
		}

		if costSheet.entriesInAccountingPeriod.isEmpty {
			noEntriesTextView.isHidden = false
		} else {
			noEntriesTextView.isHidden = true
			sortEntries()
			if isLoadingViewsForFirstTime {
				isLoadingViewsForFirstTime = false
			} else {
				transactionsTableView.reloadData()
			}
		}
		transferEntryIndexPath = nil
	}

	private func setUpTableView() {
		transactionsTableViewDataSource.dataSource = self
		transactionsTableView.backgroundColor = TintedWhiteColor
		transactionsTableView.register(UINib(nibName: "TransactionsTableViewCell", bundle: nil), forCellReuseIdentifier: "TransactionsTableViewCell")
		transactionsTableView.dataSource = transactionsTableViewDataSource
		transactionsTableView.tableFooterView = footerViewForTableView
	}
	
	private func updateNavigationBar(for costSheet: CostSheet) {
		costSheetNameLabel.text = costSheet.name
		accountingPeriodLabel.text = accountingPeriodNavigationBarLabelText
	}

	// MARK: Navigation
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		switch segue.identifier {
		case CostSheetEntrySegue:
			guard let costSheetEntryViewController = segue.destination as? CostSheetEntryViewController,
				let sender = sender as? [String: Any] else {
					assertionFailure()
					return
			}
			costSheetEntryViewController.setup(documentHandler: documentHandler, costSheetId: costSheetId)
			if let oldEntry = sender["oldEntry"] as? CostSheetEntry {
				costSheetEntryViewController.oldEntry = oldEntry
			} else {
				if let _ = sender["isAmountTransfer"] {
					costSheetEntryViewController.entryType = .expense
					costSheetEntryViewController.isDirectAmountTransfer = true
				} else {
					guard let entryType = sender["entryType"] as? EntryType else {
						assertionFailure()
						return
					}
					costSheetEntryViewController.entryType = entryType
				}
			}
		case TransferEntrySegue:
			guard let transferEntryTableViewController = (segue.destination as? UINavigationController)?.topViewController as? TransferEntryTableViewController else {
				assertionFailure()
				return
			}
			transferEntryTableViewController.setup(dataSource: self, documentHandler: documentHandler)
		case CostSheetSettingsSegue:
			guard let costSheetSettingsViewController = segue.destination as? CostSheetSettingsViewController else {
				assertionFailure()
				return
			}
			costSheetSettingsViewController.setup(documentHandler: documentHandler, costSheetId: costSheetId)
		default:
			break
		}
	}

	// MARK: View functions
	private var footerViewForTableView: UIView? {
		guard let costSheet = documentHandler.getDocument().costSheetWithId(costSheetId) else {
			assertionFailure("Could not get costSheet")
			return nil
		}
		var labelText: String?
		var balanceAmount: Float?
		if AccountingPeriod(rawValue: accountingPeriodFormat)! == .all {
			labelText = "Initial balance"
			balanceAmount = costSheet.initialBalance
		} else if shouldCarryOverBalance {
			guard let (startDate, _) = accountingPeriodDateRange else {
				assertionFailure()
				return nil
			}
			labelText = "Carry over"
			balanceAmount = costSheet.balanceBefore(startDate)
		}
		if let labelText = labelText, var balanceAmount = balanceAmount {
			var frame = CGRect()
			frame.origin.x = 0
			frame.origin.y = 0
			frame.size.width = self.view.frame.size.width
			frame.size.height = 40
			let headerView = UIView(frame: frame)

			// Left label
			let padding: CGFloat = 30
			frame.origin.y = 0
			frame.origin.x = padding
			frame.size.width = 0.65 * self.view.frame.width

			let leftLabel = UILabel(frame: frame)
			leftLabel.text = labelText
			leftLabel.backgroundColor = .clear
			leftLabel.font = UIFont.boldSystemFont(ofSize: 15)
			headerView.addSubview(leftLabel)

			// Balance label
			frame.size.width = 0.1 * self.view.frame.width
			frame.origin.x = self.view.frame.width - frame.width - padding
			let balanceLabel = UILabel(frame: frame)
			balanceLabel.font = UIFont.systemFont(ofSize: UIFont.smallSystemFontSize)
			balanceLabel.backgroundColor = .clear
			if balanceAmount < 0 {
				balanceLabel.textColor = DarkExpenseColor
			} else {
				balanceLabel.textColor = DarkIncomeColor
			}
			if balanceAmount < 0 {
				balanceAmount *= -1
			}
			balanceLabel.text = String(balanceAmount)
			headerView.addSubview(balanceLabel)

			return headerView
		}
		return nil
	}

	private func updateAmountLabel() {
		guard let costSheet = documentHandler.getDocument().costSheetWithId(costSheetId) else {
			assertionFailure("Could not get costSheet")
			return
		}

		var balance = costSheet.balanceInAccountingPeriod
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
		guard let costSheet = documentHandler.getDocument().costSheetWithId(costSheetId) else {
			assertionFailure("Could not get costSheet")
			return
		}

		let entries = costSheet.entriesInAccountingPeriod.sorted(by: { (entry1, entry2) -> Bool in
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
		var entriesSortedByCategory = [String: [CostSheetEntry]]()
		let document = documentHandler.getDocument()
		for category in document.categories {
			entriesSortedByCategory[category.name] = [CostSheetEntry]()
		}

		for entry in entriesSortedByDate {
			guard let category = document.getCategory(withId: entry.categoryID) else { continue }
			entriesSortedByCategory[category.name]?.append(entry)
		}

		var i = 0
		for (categoryName, entries) in entriesSortedByCategory {
			if entries.count == 0 {
				continue
			}

			let dict = [categoryName: entries]
			sortedEntriesForTableView[i] = dict
			i += 1
		}
	}

	private func sortEntriesByPlace() {
		guard let costSheetEntries = documentHandler.getDocument().costSheetWithId(costSheetId)?.entriesInAccountingPeriod else {
			assertionFailure("Could not get costSheet")
			return
		}
		var entriesSortedByPlace = [String: [CostSheetEntry]]()
		for entry in costSheetEntries {
			if !entry.hasPlaceID {
				if entriesSortedByPlace["No place"] == nil {
					entriesSortedByPlace["No place"] = [CostSheetEntry]()
				}
				entriesSortedByPlace["No place"]?.append(entry)
			} else {
				guard let entryPlace = documentHandler.getDocument().getPlace(withId: entry.placeID) else {
					assertionFailure("Could not get place by Id")
					return
				}
				if entriesSortedByPlace[entryPlace.name] == nil {
					entriesSortedByPlace[entryPlace.name] = [CostSheetEntry]()
				}
				entriesSortedByPlace[entryPlace.name]?.append(entry)
			}
		}

		var i = 0
		let entriesWithoutPlace = entriesSortedByPlace["No place"]
		if let entriesWithoutPlace = entriesWithoutPlace {
			sortedEntriesForTableView[i] = ["No place": entriesWithoutPlace]
			i += 1
		}

		let sortedEntriesWithPlace = entriesSortedByPlace
			.filter { $0.key != "No place" }
			.sorted { $0.key < $1.key }
		for (placeName, entries) in sortedEntriesWithPlace {
			sortedEntriesForTableView[i] = [placeName: entries]
			i += 1
		}
	}

	func getSortedEntry(at indexPath: IndexPath) -> CostSheetEntry? {
		guard let entries = sortedEntriesForTableView[indexPath.section] else {
			assertionFailure()
			return nil
		}
		return Array(entries)[0].value[indexPath.row]
	}

	// Misc. functions
	private func deleteEntry(at indexPath: IndexPath) {
		guard let deleteEntryId = getSortedEntry(at: indexPath)?.id else {
			assertionFailure()
			return
		}

		documentHandler.deleteCostSheetEntry(withId: deleteEntryId, inCostSheetWithId: costSheetId)

		if self.classificationMode != .date {
			sortEntriesByDate()
		}
		sortEntries()
		transactionsTableView.beginUpdates()
		if transactionsTableView.numberOfRows(inSection: indexPath.section) == 1 {
			transactionsTableView.deleteSections([indexPath.section], with: .bottom)
		} else {
			transactionsTableView.deleteRows(at: [indexPath], with: .left)
		}
		transactionsTableView.endUpdates()

		updateAmountLabel()
	}

	// MARK: Util funtions
	private func entry(at indexPath: IndexPath) -> CostSheetEntry? {
		if let entryToTransfer = getSortedEntry(at: indexPath) {
			return entryToTransfer
		}
		return nil
	}

}

// MARK: IBActions
private extension CostSheetViewController {

	@IBAction func expenseButtonPressed(_ sender: Any) {
		performSegue(withIdentifier: CostSheetEntrySegue, sender: ["entryType": EntryType.expense])
	}

	@IBAction func incomeButtonPressed(_ sender: Any) {
		performSegue(withIdentifier: CostSheetEntrySegue, sender: ["entryType": EntryType.income])
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
		sectionsToHide.removeAll()
		transactionsTableView.reloadData()
	}

	@IBAction func transferAmountButtonPressed(_ sender: Any) {
		performSegue(withIdentifier: CostSheetEntrySegue, sender: ["isAmountTransfer": true])
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
			let document = self.documentHandler.getDocument()
			guard document.costSheets.count > 1 else {
				self.showAlertSaying("No other cost sheets to move entry to. Create more cost sheets.")
				return
			}

			guard let entryToTransfer = self.entry(at: indexPath),
				let entryToTransferCategory = document.getCategory(withId: entryToTransfer.categoryID),
				entryToTransferCategory.name != "Transfer" else {
					self.showAlertSaying("Cannot move transfer entries.")
					return
			}

			self.transferEntryIndexPath = indexPath
			self.performSegue(withIdentifier: TransferEntrySegue, sender: nil)
		}
		transferEntryAction.backgroundColor = .darkGray
		let deleteEntryAction = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
			self.deleteEntry(at: indexPath)
		}
		return [deleteEntryAction, transferEntryAction]
	}

	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return 40
	}

	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		guard let entries = sortedEntriesForTableView[section] else {
			assertionFailure("dataSource not set")
			return nil
		}
		var frame = tableView.frame
		frame.origin.y = 0
		frame.size.height = 40
		let entriesArray = Array(entries)[0]
		let title = entriesArray.key
		let sectionBalance = entriesArray.value.reduce(0) { (balance, entry) -> Float in
			switch entry.type {
			case .income:
				return balance + entry.amount
			case .expense:
				return balance - entry.amount
			}
		}
		let headerView = TableViewSectionHeaderView(frame: frame, section: section, text: title, balance: sectionBalance, delegate: self)
		return headerView
	}

}

// MARK: TableViewSectionHeaderViewDelegate
extension CostSheetViewController: TableViewSectionHeaderViewDelegate {

	func sectionHeaderViewTapped(section: Int) {
		if sectionsToHide.contains(section) {
			sectionsToHide.remove(section)
		} else {
			sectionsToHide.insert(section)
		}
		transactionsTableView.reloadData()
	}

}

// MARK: TransferEntryTableViewControllerDataSource
extension CostSheetViewController: TransferEntryTableViewControllerDataSource {

	var fromCostSheetId: String {
		return costSheetId
	}

	var entryToTransferId: String {
		guard let transferEntryIndexPath = transferEntryIndexPath,
			let entryToTransfer = entry(at: transferEntryIndexPath) else {
				assertionFailure("transferEntryIndexPath not set")
				return ""
		}
		return entryToTransfer.id
	}

}
