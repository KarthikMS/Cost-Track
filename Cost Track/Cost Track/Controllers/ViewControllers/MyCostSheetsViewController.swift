//
//  MyCostSheetsViewController.swift
//  Cost Track
//
//  Created by Karthik M S on 14/07/18.
//  Copyright © 2018 Karthik M S. All rights reserved.
//

import UIKit

class MyCostSheetsViewController: UIViewController, NewCostSheetViewControllerDataSource {

	// MARK: IBOutlets
	@IBOutlet weak var topBar: UIView!
	@IBOutlet weak var totalAmountLabel: UILabel!
	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var noCostSheetsTextView: UITextView!
	@IBOutlet weak var accountingPeriodLabel: UILabel!
	
	// MARK: Properties
	var (document, isNewDocument) = CTFileManager.getDocument()
	var selectedCostSheetId = ""
	private var shouldUpdateViews = false
	private var sectionsToHide = Set<Int>()
	private let accountingPeriodViewController = AccountingPeriodViewController()

	// MARK: UIViewController functions
    override func viewDidLoad() {
        super.viewDidLoad()

		if isNewDocument {
			CTFileManager.saveDocument(document)
			UserDefaults.standard.setValue(true, forKey: BalanceCarryOver)
			UserDefaults.standard.setValue(1, forKey: StartDayForMonthlyAccountingPeriod)
		}

		initAccountingPeriodViewController()

		if document.costSheets.isEmpty {
			noCostSheetsTextView.isHidden = false
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
			if document.costSheets.isEmpty {
				noCostSheetsTextView.isHidden = false
			} else {
				noCostSheetsTextView.isHidden = true
				tableView.reloadData()
			}
			shouldUpdateViews = false
		}

		selectedCostSheetId = ""
	}

	// MARK: Navigation
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		guard let identifier = segue.identifier else {
			return
		}
		switch identifier {
		case CostSheetSegue:
			guard let costSheetViewController = segue.destination as? CostSheetViewController else {
				return
			}
			costSheetViewController.setup(dataSource: self, deltaDelegate: self)
		case NewCostSheetSegue:
			guard let newCostSheetViewController = segue.destination as? NewCostSheetViewController else {
				return
			}
			newCostSheetViewController.setup(dataSource: self, deltaDelegate: self)
		case SettingsSegue:
			guard let settingsTableViewController = segue.destination as? SettingsTableViewController else {
				return
			}
			settingsTableViewController.setup(delegate: self)
		default:
			break
		}
	}

	// MARK: View functions
	private func updateTopBar() {
		var totalAmount = document.totalDisplayAmount
		if totalAmount < 0 {
			topBar.backgroundColor = DarkExpenseColor
			totalAmount *= -1
		} else {
			topBar.backgroundColor = DarkIncomeColor
		}
		totalAmountLabel.text = String(totalAmount)
	}

	private func initAccountingPeriodViewController() {
		var frame = CGRect()
		frame.size.width = 0.95 * view.frame.size.width
		frame.size.height = 0
		frame.origin.x = (view.frame.size.width - frame.size.width) / 2
		frame.origin.y = navigationController!.navigationBar.frame.origin.y + navigationController!.navigationBar.frame.size.height + 5
		accountingPeriodViewController.view.frame = frame
		view.addSubview(accountingPeriodViewController.view)
		accountingPeriodViewController.view.isHidden = true
		accountingPeriodViewController.delegate = self
	}

	private func showAccountingPeriodViewController() {
		var frame = accountingPeriodViewController.view.frame
		guard frame.size.height != 300 else {
			return
		}
		frame.size.height = 300
		UIView.animate(withDuration: 0.5, animations: {
			self.accountingPeriodViewController.view.frame = frame
		}) { (completed) in
			if completed {
				self.accountingPeriodViewController.view.isHidden = false
			}
		}
	}

	private func hideAccountingPeriodViewController() {
		var frame = accountingPeriodViewController.view.frame
		guard frame.size.height != 0 else {
			return
		}
		frame.size.height = 0
		UIView.animate(withDuration: 0.5, animations: {
			self.accountingPeriodViewController.view.frame = frame
		}) { (completed) in
			if completed {
				self.accountingPeriodViewController.view.isHidden = true
			}
		}
	}

	// MARK: Misc. functions
	private func costSheetAtIndexPath(_ indexPath: IndexPath) -> CostSheet {
		let groupsWithCostSheets = document.groupsWithCostSheets
		return document.costSheetsInGroup(groupsWithCostSheets[indexPath.section])[indexPath.row]
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
		let deleteCostSheetComp = DeltaUtil.getComponentToDeleteCostSheet(withId: id, in: document)
		sendDeltaComponents([deleteCostSheetComp])
		
		if !document.hasCostSheetsInOtherGroups {
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
		if document.costSheets.isEmpty {
			noCostSheetsTextView.isHidden = false
		}
	}
}

// MARK: IBActions
private extension MyCostSheetsViewController {

	@IBAction func navigationTitleViewTapped(_ sender: Any) {
		if accountingPeriodViewController.view.frame.size.height == 0 {
			showAccountingPeriodViewController()
		} else {
			hideAccountingPeriodViewController()
		}
	}

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
		return document.groupsWithCostSheets.count
	}

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if sectionsToHide.contains(section) {
			return 0
		}
		let groupsWithCostSheets = document.groupsWithCostSheets
		return document.costSheetsInGroup(groupsWithCostSheets[section]).count
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
		performSegue(withIdentifier: "CostSheetSegue", sender: nil)
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
		if !document.hasCostSheetsInOtherGroups {
			return 0
		}
		return 40
	}

	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		if !document.hasCostSheetsInOtherGroups {
			return nil
		}

		var frame = tableView.frame
		frame.origin.y = 0
		frame.size.height = 40
		let title = document.groupsWithCostSheets[section].name
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

extension MyCostSheetsViewController: CostSheetDataSource {

	var costSheetId: String {
		return selectedCostSheetId
	}

}

// MARK: SettingsTableViewControllerDelegate
extension MyCostSheetsViewController: SettingsTableViewControllerDelegate {

	func refreshView() {
		(document, isNewDocument) = CTFileManager.getDocument()
		if isNewDocument {
			CTFileManager.saveDocument(document)
			UserDefaults.standard.setValue(true, forKey: BalanceCarryOver)
			UserDefaults.standard.setValue(1, forKey: StartDayForMonthlyAccountingPeriod)
		}
		shouldUpdateViews = true
	}

}

// MARK: DeltaDelegate
extension MyCostSheetsViewController: DeltaDelegate {

	func sendDeltaComponents(_ components: [DocumentContentOperation.Component]) {
		for component in components {
			do {
				var decoder = try DeltaDataApplier(fieldString: component.fields, value: component.value.inBytes.value, operationType: component.opType)
				try document.decodeMessage(decoder: &decoder)
				shouldUpdateViews = true
			} catch {
				assertionFailure(error.localizedDescription)
			}
		}
		CTFileManager.saveDocument(document)
	}

}

// MARK: AccountingPeriodViewControllerDelegate
extension MyCostSheetsViewController: AccountingPeriodViewControllerDelegate {

	func cancelButtonPressed() {
		hideAccountingPeriodViewController()
	}

	func accountingPeriodChanged() {
		tableView.reloadData()
		hideAccountingPeriodViewController()
	}

}
