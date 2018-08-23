//
//  NewCostSheetViewController.swift
//  Cost Track
//
//  Created by Karthik M S on 15/07/18.
//  Copyright © 2018 Karthik M S. All rights reserved.
//

import UIKit

protocol NewCostSheetViewControllerDataSource: GroupSelectTableViewControllerDataSource {
	var defaultCostSheetName: String { get }
	func getGroup(withId id: String) -> CostSheetGroup
}

protocol NewCostSheetViewControllerDelegate {
	func didCreateCostSheet(_ costSheet: CostSheet)
	func didCreateGroup(withName name: String)
}

class NewCostSheetViewController: UIViewController {

	// MARK: IBOutlets
	@IBOutlet weak var settingsTableView: CostSheetSettingsTableView!

	// MARK: Properties
	var delegate: NewCostSheetViewControllerDelegate?
	var dataSource: NewCostSheetViewControllerDataSource?
	var selectedGroupId = NotSetGroupID

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
		newCostSheet.name = dataSource.defaultCostSheetName
		newCostSheet.initialBalance = 0
		newCostSheet.id = UUID().uuidString
		newCostSheet.group = CostSheetGroup()
		newCostSheet.group.name = NotSetGroupName
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
			groupSelectTableViewController.groupSelectTableViewControllerDataSource = self.dataSource
			groupSelectTableViewController.groupSelectTableViewControllerDelegate = self
		}
	}

}

// MARK: IBActions
extension NewCostSheetViewController {

	@IBAction private func createButtonPressed(_ sender: Any) {
		settingsTableView.updateCostSheet()
		var costSheet = settingsTableView.costSheet
		if costSheet.name == "" {
			// Show dialog to enter costSheet name
			return
		}

		costSheet.lastModifiedDate = Date().data

		delegate?.didCreateCostSheet(costSheet)
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
extension NewCostSheetViewController: GroupSelectTableViewControllerDelegate {

	func didSelectGroup(id: String) {
		guard let dataSource = dataSource else {
			assertionFailure()
			return
		}
		selectedGroupId = id
		settingsTableView.costSheet.group = dataSource.getGroup(withId: id)
		settingsTableView.updateCostSheet()
		settingsTableView.reloadData()
	}

	func didCreateGroup(withName name: String) {
		guard let delegate = delegate else {
			assertionFailure()
			return
		}
		delegate.didCreateGroup(withName: name)
	}

}
