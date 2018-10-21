//
//  NewCostSheetViewController.swift
//  Cost Track
//
//  Created by Karthik M S on 15/07/18.
//  Copyright © 2018 Karthik M S. All rights reserved.
//

import UIKit

protocol NewCostSheetViewControllerDataSource {
	var document: Document { get }
}

class NewCostSheetViewController: UIViewController {

	// MARK: IBOutlets
	@IBOutlet weak var settingsTableView: CostSheetSettingsTableView!

	// MARK: Properties
	weak var deltaDelegate: DeltaDelegate?
	var dataSource: NewCostSheetViewControllerDataSource?
	var selectedGroupId = NotSetGroup.id

	// MARK: UIViewController functions
    override func viewDidLoad() {
        super.viewDidLoad()
		guard let dataSource = dataSource else {
			assertionFailure()
			return
		}

		settingsTableView.setMode(.newCostSheet)
		settingsTableView.costSheetSettingsTableViewDelegate = self

		var newCostSheet = CostSheet()
		newCostSheet.name = dataSource.document.defaultNewCostSheetName
		newCostSheet.initialBalance = 0
		newCostSheet.id = UUID().uuidString
		newCostSheet.group = CostSheetGroup()
		newCostSheet.group.name = NotSetGroup.name
		newCostSheet.group.id = selectedGroupId
		settingsTableView.costSheet = newCostSheet
    }

	// MARK: Navigation
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == GroupSelectSegue {
			guard let groupSelectTableViewController = segue.destination as? GroupSelectTableViewController else {
				assertionFailure()
				return
			}
			groupSelectTableViewController.selectedGroupID = selectedGroupId
			groupSelectTableViewController.groupSelectTableViewControllerDataSource = self
			groupSelectTableViewController.groupSelectTableViewControllerDelegate = self
			groupSelectTableViewController.deltaDelegate = deltaDelegate
		}
	}

}

// MARK: IBActions
private extension NewCostSheetViewController {

	@IBAction func createButtonPressed(_ sender: Any) {
		guard let deltaDelegate = deltaDelegate,
			let document = dataSource?.document else {
				assertionFailure()
				return
		}

		settingsTableView.updateCostSheet()
		var costSheet = settingsTableView.costSheet
		guard costSheet.name != "" else {
			showAlertSaying("Please enter a name for the cost sheet.")
			return
		}
		guard document.isCostSheetNameNew(costSheet.name) else {
			showAlertSaying("\'\(costSheet.name)\' already exists. Please enter a different name.")
			return
		}

		costSheet.createdOnDate = Date().data
		costSheet.lastModifiedDate = costSheet.createdOnDate
		// TODO: includeInOverallTotal
		costSheet.includeInOverallTotal = true

		// Delta
		let insertCostSheetComp = DeltaUtil.getComponentToInsertCostSheet(costSheet, in: document)
		deltaDelegate.sendDeltaComponents([insertCostSheetComp])

		navigationController?.popViewController(animated: true)
	}

}

// MARK: CostSheetSettingsTableViewDelegate
extension NewCostSheetViewController: CostSheetSettingsTableViewDelegate {

	func didSelectGroupCell() {
		performSegue(withIdentifier: GroupSelectSegue, sender: nil)
	}

}

// MARK: GroupSelectTableViewControllerDataSource
extension NewCostSheetViewController: GroupSelectTableViewControllerDataSource {

	var document: Document {
		guard let document = dataSource?.document else {
			assertionFailure()
			return Document()
		}
		return document
	}

}

// MARK: GroupSelectTableViewControllerDelegate
extension NewCostSheetViewController: GroupSelectTableViewControllerDelegate {

	func didSelectGroup(id: String) {
		guard let group = dataSource?.document.getGroup(withId: id) else {
			assertionFailure()
			return
		}
		selectedGroupId = id
		settingsTableView.costSheet.group = group
		settingsTableView.updateCostSheet()
		settingsTableView.reloadData()
	}

}
