//
//  CostSheetSettingsViewController.swift
//  Cost Track
//
//  Created by Karthik M S on 03/11/18.
//  Copyright © 2018 Karthik M S. All rights reserved.
//

import UIKit

class CostSheetSettingsViewController: UIViewController {

	// MARK: IBOutlets
	@IBOutlet weak var settingsTableView: CostSheetSettingsTableView!

	// MARK: Properties
	private weak var documentHandler: DocumentHandler!
	private var costSheetId: String!
	func setup(documentHandler: DocumentHandler, costSheetId: String) {
		self.documentHandler = documentHandler
		self.costSheetId = costSheetId
	}
	var selectedGroupId: String!

	// MARK: NSViewController functions
	override func viewDidLoad() {
        super.viewDidLoad()

		settingsTableView.setUp(documentHandler: documentHandler, mode: .costSheetSettings)
		settingsTableView.costSheetSettingsTableViewDelegate = self
		guard let costSheet = documentHandler.getDocument().costSheetWithId(costSheetId) else {
			assertionFailure()
			return
		}
		settingsTableView.costSheet = costSheet

		selectedGroupId = costSheet.groupID
    }

	// MARK: Navigation
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == GroupSelectFromCostSheetSettingsSegue {
			guard let groupSelectTableViewController = segue.destination as? GroupTableViewController else {
				assertionFailure()
				return
			}
			groupSelectTableViewController.selectedGroupID = selectedGroupId
			groupSelectTableViewController.setup(documentHandler: documentHandler, selectionDelegate: self, mode: .select)
		}
	}
	
}

// MARK: CostSheetSettingsTableViewDelegate
extension CostSheetSettingsViewController: CostSheetSettingsTableViewDelegate {

	func didSelectGroupCell() {
		performSegue(withIdentifier: GroupSelectFromCostSheetSettingsSegue, sender: nil)
	}

}

// MARK: GroupSelectTableViewControllerDelegate
extension CostSheetSettingsViewController: GroupSelectionDelegate {

	func didSelectGroup(id: String) {
		selectedGroupId = id
		settingsTableView.costSheet.groupID = id
		settingsTableView.updateCostSheet()
		settingsTableView.reloadData()
	}

}

// MARK: IBActions
private extension CostSheetSettingsViewController {

	@IBAction func saveButtonPressed(_ sender: Any) {
		settingsTableView.updateCostSheet()
		var costSheet = settingsTableView.costSheet
		guard costSheet.name != "" else {
			showAlertSaying("Please enter a name for the cost sheet.")
			return
		}
		let document = documentHandler.getDocument()
		guard document.isCostSheetNameNew(costSheet.name, excludingCostSheetId: costSheet.id) else {
			showAlertSaying("\'\(costSheet.name)\' already exists. Please enter a different name.")
			return
		}
		documentHandler.updateCostSheet(costSheet)
		navigationController?.popViewController(animated: true)
	}

}
