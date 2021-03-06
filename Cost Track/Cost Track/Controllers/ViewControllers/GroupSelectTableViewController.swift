//
//  GroupSelectTableViewController.swift
//  Cost Track
//
//  Created by Karthik M S on 22/08/18.
//  Copyright © 2018 Karthik M S. All rights reserved.
//

import UIKit

protocol GroupSelectTableViewControllerDataSource: class {
	var document: Document { get }
}

protocol GroupSelectTableViewControllerDelegate: class {
	func didSelectGroup(id: String)
}

class GroupSelectTableViewController: UITableViewController {

	// MARK: Properties
	var selectedGroupID = ""
	private weak var groupSelectTableViewControllerDataSource: GroupSelectTableViewControllerDataSource!
	private weak var groupSelectTableViewControllerDelegate: GroupSelectTableViewControllerDelegate!
	private weak var deltaDelegate: DeltaDelegate!
	func setup(dataSource: GroupSelectTableViewControllerDataSource, delegate: GroupSelectTableViewControllerDelegate, deltaDelegate: DeltaDelegate) {
		self.groupSelectTableViewControllerDataSource = dataSource
		self.groupSelectTableViewControllerDelegate = delegate
		self.deltaDelegate = deltaDelegate
	}
	private var alertOkAction: UIAlertAction?

	// MARK: UIViewController functions
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)

		groupSelectTableViewControllerDelegate?.didSelectGroup(id: selectedGroupID)
	}

}

// MARK: UITableViewDataSource
extension GroupSelectTableViewController {

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return groupSelectTableViewControllerDataSource.document.groups.count
	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "SelectGroupCell", for: indexPath)
		let group = groupSelectTableViewControllerDataSource.document.groups[indexPath.row]
		cell.textLabel?.text = group.name
		if group.id == selectedGroupID {
			cell.accessoryType = .checkmark
		} else {
			cell.accessoryType = .none
		}
		return cell
	}

	override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
		guard groupSelectTableViewControllerDataSource.document.groups[indexPath.row].id != NotSetGroup.id else {
			return false
		}
		return true
	}

	override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
		let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") { (deleteAction, indexPath) in
			let groupToDelete = self.groupSelectTableViewControllerDataSource.document.groups[indexPath.row]
			if self.groupSelectTableViewControllerDataSource.document.hasCostSheets(in: groupToDelete) {
				self.showAlertForGroupDeletionConfirmation(deletionIndexPath: indexPath)
			} else {
				self.deleteGroup(at: indexPath)
			}
		}
		return [deleteAction]
	}

	private func deleteGroup(at indexPath: IndexPath) {
		let document = groupSelectTableViewControllerDataSource.document

		// Delta Component
		let deleteGroupComp = DeltaUtil.getComponentToDeleteGroup(at: indexPath.row, in: document)
		let moveCostSheetsComps = DeltaUtil.getComponentsToMoveCostSheets(from: document.groups[indexPath.row], to: NotSetGroup, in: document)
		var deltaComps = [deleteGroupComp]
		deltaComps.append(contentsOf: moveCostSheetsComps)
		deltaDelegate.sendDeltaComponents(deltaComps)

		if indexPath.row > 0 {
			selectedGroupID = document.groups[indexPath.row - 1].id
		} else {
			selectedGroupID = document.groups[0].id
		}
		self.tableView.reloadData()
	}

	private func showAlertForGroupDeletionConfirmation(deletionIndexPath: IndexPath) {
		let deletionGroup = groupSelectTableViewControllerDataSource.document.groups[deletionIndexPath.row]
		let costSheetCount = groupSelectTableViewControllerDataSource.document.numberOfCostSheets(in: deletionGroup)

		let message: String
		if costSheetCount == 1 {
			message = "There is a cost sheet in \(deletionGroup.name). It will NOT be deleted. It will not belong to any group."
		} else {
			message = "There are \(costSheetCount) cost sheet(s) in \(deletionGroup.name). They will NOT be deleted. They will not belong to any group."
		}

		let alertController = UIAlertController(title: "Delete Group", message: message, preferredStyle: .alert)
		alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (cancelAction) in
			alertController.dismiss(animated: true)
		}))
		alertController.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { (deleteAction) in
			self.deleteGroup(at: deletionIndexPath)
			alertController.dismiss(animated: true)
		}))
		present(alertController, animated: true)
	}

}

// MARK: UITableViewDelegate
extension GroupSelectTableViewController {

	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let group = groupSelectTableViewControllerDataSource.document.groups[indexPath.row]
		selectedGroupID = group.id
		tableView.reloadData()
	}

}

// MARK: IBActions
private extension GroupSelectTableViewController {

	@IBAction func createGroupButtonPressed(_ sender: Any) {
		let alertController = UIAlertController(title: "New Group", message: "Please enter a group name.", preferredStyle: .alert)
		alertController.addTextField { (textField) in
			textField.placeholder = "Group Name"
			textField.addTarget(self, action: #selector(self.alertTextFieldTextDidChange(textField:)), for: .editingChanged)
		}
		let cancelAction = UIAlertAction( title: "Cancel", style: .cancel, handler: { (cancelAction) in
			alertController.dismiss(animated: true)
		})
		alertOkAction = UIAlertAction(title: "Ok", style: .default, handler: { (okAction) in
			guard let textField = alertController.textFields?.first,
				let groupName = textField.text else {
					assertionFailure()
					return
			}
			let document = self.groupSelectTableViewControllerDataSource.document

			guard document.isGroupNameNew(groupName) else {
				self.showAlertSaying("\'\(groupName)\' already exists. Please enter a different name.")
				return
			}

			// New group
			var newGroup = CostSheetGroup()
			newGroup.name = groupName
			newGroup.id = UUID().uuidString

			// Delta Component
			let insertGroupComponent = DeltaUtil.getComponentToInsertGroup(newGroup, in: document)
			self.deltaDelegate.sendDeltaComponents([insertGroupComponent])

			self.selectedGroupID = newGroup.id
			self.tableView.reloadData()
			alertController.dismiss(animated: true)
		})
		alertOkAction?.isEnabled = false
		alertController.addAction(cancelAction)
		alertController.addAction(alertOkAction!)
		present(alertController, animated: true)
	}

	@objc
	func alertTextFieldTextDidChange(textField: UITextField) {
		guard let alertOkAction = alertOkAction else {
			assertionFailure()
			return
		}
		if textField.text == "" {
			alertOkAction.isEnabled = false
		} else {
			alertOkAction.isEnabled = true
		}
	}

}
