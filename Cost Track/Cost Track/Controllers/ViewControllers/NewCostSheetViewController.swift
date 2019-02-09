//
//  NewCostSheetViewController.swift
//  Cost Track
//
//  Created by Karthik M S on 15/07/18.
//  Copyright © 2018 Karthik M S. All rights reserved.
//

import UIKit

class NewCostSheetViewController: UIViewController {

	// MARK: IBOutlets
	@IBOutlet weak var settingsTableView: CostSheetSettingsTableView!

	// MARK: Properties
	private weak var documentHandler: DocumentHandler!
	func setup(documentHandler: DocumentHandler) {
		self.documentHandler = documentHandler
	}
	var selectedGroupId = NotSetGroupId

	// MARK: UIViewController functions
    override func viewDidLoad() {
        super.viewDidLoad()

		settingsTableView.setUp(documentHandler: documentHandler, mode: .newCostSheet)
		settingsTableView.costSheetSettingsTableViewDelegate = self

		var newCostSheet = CostSheet()
		newCostSheet.name = documentHandler.getDocument().defaultNewCostSheetName
		newCostSheet.initialBalance = 0
		newCostSheet.includeInOverallTotal = true
		newCostSheet.id = UUID().uuidString
		newCostSheet.groupID = selectedGroupId
		settingsTableView.costSheet = newCostSheet
    }

	// MARK: Navigation
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == GroupSelectSegue {
			guard let groupSelectTableViewController = segue.destination as? GroupTableViewController else {
				assertionFailure()
				return
			}
			groupSelectTableViewController.selectedGroupID = selectedGroupId
			groupSelectTableViewController.setup(documentHandler: documentHandler, selectionDelegate: self, mode: .select)
		}
	}

}

// MARK: IBActions
private extension NewCostSheetViewController {

	@IBAction func createButtonPressed(_ sender: Any) {
		settingsTableView.updateCostSheet()
		var costSheet = settingsTableView.costSheet
		guard costSheet.name != "" else {
			showAlertSaying("Please enter a name for the cost sheet.")
			return
		}
		guard documentHandler.getDocument().isCostSheetNameNew(costSheet.name) else {
			showAlertSaying("\'\(costSheet.name)\' already exists. Please enter a different name.")
			return
		}
		costSheet.createdOnDate = Date().data
		costSheet.lastModifiedDate = costSheet.createdOnDate
		documentHandler.addCostSheet(costSheet)
		navigationController?.popViewController(animated: true)
	}

}

// MARK: CostSheetSettingsTableViewDelegate
extension NewCostSheetViewController: CostSheetSettingsTableViewDelegate {

	func didSelectGroupCell() {
		performSegue(withIdentifier: GroupSelectSegue, sender: nil)
	}

}

// MARK: GroupSelectTableViewControllerDelegate
extension NewCostSheetViewController: GroupSelectionDelegate {

	func didSelectGroup(id: String) {
		selectedGroupId = id
		settingsTableView.costSheet.groupID = id
		settingsTableView.updateCostSheet()
		settingsTableView.reloadData()
	}

}
