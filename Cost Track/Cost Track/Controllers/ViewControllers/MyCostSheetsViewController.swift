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
	@IBOutlet weak var costSheetView: UIView!
	@IBOutlet weak var infoLabel: UILabel!
	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var noCostSheetsTextView: UITextView!
	@IBOutlet weak var accountingPeriodLabel: UILabel!

	// MARK: Properties
//	var (document, isNewDocument) = CTFileManager.getDocument()
	var documentHandler: DocumentHandler!
	var selectedCostSheetId = ""
	private var sectionsToHide = Set<Int>()
	private let accountingPeriodViewController = AccountingPeriodViewController()

	// MARK: UIViewController functions
    override func viewDidLoad() {
        super.viewDidLoad()

		let (document, isNewDocument) = CTFileManager.getDocument()
		documentHandler = DocumentHandler(document: document)
		if isNewDocument {
			CTFileManager.saveDocument(document)
			UserDefaults.standard.setValue(true, forKey: BalanceCarryOver)
			UserDefaults.standard.setValue(1, forKey: StartDayForMonthlyAccountingPeriod)
		}

		initAccountingPeriodViewController()
		updateNavigationBarAccountingLabel()

		tableView.register(UINib(nibName: "CostSheetTableViewCell", bundle: nil), forCellReuseIdentifier: "CostSheetTableViewCell")
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)

		sectionsToHide.removeAll()
		updateTopBar()
		updateInfoLabel()
		updateCostSheetView()
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
			costSheetViewController.setup(documentHandler: documentHandler, costSheetId: selectedCostSheetId)
		case NewCostSheetSegue:
			guard let newCostSheetViewController = segue.destination as? NewCostSheetViewController else {
				return
			}
			newCostSheetViewController.setup(documentHandler: documentHandler)
		case SettingsSegue:
			guard let settingsTableViewController = segue.destination as? SettingsTableViewController else {
				return
			}
			settingsTableViewController.setup(documentHandler: documentHandler)
		default:
			break
		}
	}

	// MARK: View functions
	private func updateTopBar() {
		var totalAmount = documentHandler.getDocument().totalDisplayAmount
		if totalAmount < 0 {
			topBar.backgroundColor = DarkExpenseColor
			totalAmount *= -1
		} else {
			topBar.backgroundColor = DarkIncomeColor
		}
		totalAmountLabel.text = String(totalAmount)
	}

	private enum TimeRepresentation {
		case seconds
		case minutes
		case hours
		case days
	}

	private func updateInfoLabel() {
		guard let lastModifiedDate = documentHandler.getDocument().lastModifiedOnDate.date else {
			assertionFailure("Could not get date.")
			return
		}
		let now = Date()
		let (startDate, endDate) = lastModifiedDate.startAndEndDatesOfWeek()
		let timeString: String
		if now.isBetween(startDate, and: endDate) {
			var timeInterval = Int(now.timeIntervalSince(lastModifiedDate))
			var timeRepresentation = TimeRepresentation.seconds
			if timeInterval >= 60 {
				timeInterval /= 60
				timeRepresentation = .minutes
				if timeInterval >= 60 {
					timeInterval /= 60
					timeRepresentation = .hours
					if timeInterval >= 24 {
						timeInterval /= 24
						timeRepresentation = .days
					}
				}
			}
			switch timeRepresentation {
			case .seconds:
				timeString = "a few seconds ago"
			case .minutes:
				if timeInterval == 1 {
					timeString = "a minute ago"
				} else {
					timeString = "\(timeInterval) minutes ago"
				}
			case .hours:
				if timeInterval == 1 {
					timeString = "an hour ago"
				} else {
					timeString = "\(timeInterval) hours ago"
				}
			case .days:
				if timeInterval == 1 {
					timeString = "a day ago"
				} else {
					timeString = "\(timeInterval) days ago"
				}
			}
		} else {
			timeString = "on " + lastModifiedDate.string(format: "dd-mm-yy")
		}
		infoLabel.text = "Last modified " + timeString
	}

	private func updateCostSheetView() {
		if documentHandler.getDocument().costSheets.isEmpty {
			noCostSheetsTextView.isHidden = false
		} else {
			noCostSheetsTextView.isHidden = true
			tableView.reloadData()
		}
	}

	private func initAccountingPeriodViewController() {
		var frame = CGRect()
		frame.size.width = 0.95 * view.frame.size.width
		frame.size.height = 0
		frame.origin.x = (view.frame.size.width - frame.size.width) / 2
		frame.origin.y = navigationController!.navigationBar.frame.origin.y + navigationController!.navigationBar.frame.size.height + 5
		accountingPeriodViewController.view.frame = frame
		accountingPeriodViewController.view.clipsToBounds = true
		view.addSubview(accountingPeriodViewController.view)
		accountingPeriodViewController.view.isHidden = true
		accountingPeriodViewController.delegate = self
	}

	private func showAccountingPeriodViewController() {
		var frame = accountingPeriodViewController.view.frame
		let showFrameHeight: CGFloat = AccountingPeriod(rawValue: accountingPeriodFormat)! == .month ? 500 : 300
		guard frame.size.height != showFrameHeight else {
			return
		}
		frame.size.height = showFrameHeight
		self.accountingPeriodViewController.view.isHidden = false
		UIView.animate(withDuration: 0.5, animations: {
			self.accountingPeriodViewController.view.frame = frame
		})
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
		let document = documentHandler.getDocument()
		let groupIdsWithCostSheets = document.groupIdsWithCostSheets
		return document.costSheetsInGroupWithId(groupIdsWithCostSheets[indexPath.section])[indexPath.row]
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

	// TODO: Make this as a function in DocumentHandler
	private func deleteCostSheet(withId id: String, at indexPath: IndexPath) {
		documentHandler.deleteCostSheet(withId: id)

		if !documentHandler.getDocument().hasCostSheetsInOtherGroups {
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
		if documentHandler.getDocument().costSheets.isEmpty {
			noCostSheetsTextView.isHidden = false
		}
		updateTopBar()
		updateInfoLabel()
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
		return documentHandler.getDocument().groupIdsWithCostSheets.count
	}

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if sectionsToHide.contains(section) {
			return 0
		}
		let document = documentHandler.getDocument()
		let groupIdsWithCostSheets = document.groupIdsWithCostSheets
		return document.costSheetsInGroupWithId(groupIdsWithCostSheets[section]).count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "CostSheetTableViewCell", for: indexPath) as! CostSheetTableViewCell
		cell.setValues(for: costSheetAtIndexPath(indexPath))
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
		if !documentHandler.getDocument().hasCostSheetsInOtherGroups {
			return 0
		}
		return 40
	}

	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		let document = documentHandler.getDocument()
		if !document.hasCostSheetsInOtherGroups {
			return nil
		}

		var frame = tableView.frame
		frame.origin.y = 0
		frame.size.height = 40
		let groupId = document.groupIdsWithCostSheets[section]
		guard let groupName = document.getGroup(withId: groupId)?.name else {
			assertionFailure("Could not get group.")
			return nil
		}
		let headerView = TableViewSectionHeaderView(frame: frame, section: section, text: groupName, balance: nil, delegate: self)
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

// MARK: AccountingPeriodViewControllerDelegate
extension MyCostSheetsViewController: AccountingPeriodViewControllerDelegate {

	func cancelButtonPressed() {
		hideAccountingPeriodViewController()
	}

	func accountingPeriodChanged() {
		tableView.reloadData()
		hideAccountingPeriodViewController()
		updateNavigationBarAccountingLabel()
	}

	private func updateNavigationBarAccountingLabel() {
		accountingPeriodLabel.text = accountingPeriodNavigationBarLabelText
	}

}
