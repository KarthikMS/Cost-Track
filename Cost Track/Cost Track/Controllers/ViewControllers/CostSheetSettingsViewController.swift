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

		settingsTableView.setMode(.costSheetSettings)
		settingsTableView.costSheetSettingsTableViewDelegate = self
		guard let costSheet = documentHandler.getDocument().costSheetWithId(costSheetId) else {
			assertionFailure()
			return
		}
		settingsTableView.costSheet = costSheet

		selectedGroupId = costSheet.group.id
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

	func didGroupTableViewCell() {
		performSegue(withIdentifier: GroupSelectFromCostSheetSettingsSegue, sender: nil)
	}

}

// MARK: GroupSelectTableViewControllerDelegate
extension CostSheetSettingsViewController: GroupSelectionDelegate {

	func didSelectGroup(id: String) {
		guard let group = documentHandler.getDocument().getGroup(withId: id) else {
			assertionFailure()
			return
		}
		selectedGroupId = id
		settingsTableView.costSheet.group = group
		settingsTableView.updateCostSheet()
		settingsTableView.reloadData()
	}

}

// MARK: IBActions
private extension CostSheetSettingsViewController {

	@IBAction func saveButtonPressed(_ sender: Any) {
		settingsTableView.updateCostSheet()
//		guard let oldCostSheet = dataSource.document.costSheetWithId(dataSource.costSheetId) else {
//			assertionFailure()
//			return
//		}
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

		costSheet.lastModifiedDate = Date().data
		let updateCostSheetComp = DeltaUtil.getComponentToUpdateCostSheet(withId: costSheetId, with: costSheet, in: document)
		documentHandler.sendDeltaComponents([updateCostSheetComp])
		
		// TODO: Fix this
		/*
		var newName: String?
		var newInitialBalance: Float?
		var newIncludInOverallTotal: Bool?
		var newGroup: CostSheetGroup?

		if costSheet.name != oldCostSheet.name {
			newName = costSheet.name
		}
		if costSheet.initialBalance != oldCostSheet.initialBalance {
			newInitialBalance = costSheet.initialBalance
		}
		if costSheet.includeInOverallTotal != oldCostSheet.includeInOverallTotal {
			newIncludInOverallTotal = costSheet.includeInOverallTotal
		}
		if costSheet.group.id != oldCostSheet.group.id {
			newGroup = costSheet.group
		}

		if newName != nil || newInitialBalance != nil || newIncludInOverallTotal != nil || newGroup != nil {
			let deltaComps = DeltaUtil.getComponentsToUpdatePropertiesOfCostSheet(
				withId: costSheet.id,
				in: document,
				name: newName,
				initialBalance: newInitialBalance,
				includeInOverallTotal: newIncludInOverallTotal,
				group: newGroup,
				lastModifiedData: Date().data
			)
			deltaDelegate.sendDeltaComponents(deltaComps)
		}
		*/

		navigationController?.popViewController(animated: true)
	}

}
