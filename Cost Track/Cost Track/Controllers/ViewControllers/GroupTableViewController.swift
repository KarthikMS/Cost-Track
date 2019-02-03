//
//  GroupTableViewController.swift
//  Cost Track
//
//  Created by Karthik M S on 03/02/19.
//  Copyright © 2019 Karthik M S. All rights reserved.
//

import UIKit

enum GroupTableViewControllerMode {
	case select
	case edit
}

protocol GroupSelectionDelegate: class {
	func didSelectGroup(id: String)
}

class GroupTableViewController: UITableViewController {

	// MARK: Properties
	var selectedGroupID = ""
	private weak var documentHandler: DocumentHandler!
	private weak var groupSelectionDelegate: GroupSelectionDelegate?
	private var mode: GroupTableViewControllerMode!
	func setup(documentHandler: DocumentHandler, selectionDelegate: GroupSelectionDelegate?, mode: GroupTableViewControllerMode) {
		self.documentHandler = documentHandler
		self.groupSelectionDelegate = selectionDelegate
		self.mode = mode
	}
	private var createGroupAlertOkAction: UIAlertAction?
	private var renameGroupAlertOkAction: UIAlertAction?

	// MARK: UIViewController functions
	override func viewDidLoad() {
		super.viewDidLoad()

		if mode == .edit {
			tableView.isEditing = true
		}
	}

	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)

		groupSelectionDelegate?.didSelectGroup(id: selectedGroupID)
	}

}

// MARK: UITableViewDataSource
extension GroupTableViewController {

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return documentHandler.getDocument().groups.count
	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "GroupTableViewCell", for: indexPath)
		let group = documentHandler.getDocument().groups[indexPath.row]
		cell.textLabel?.text = group.name
		if (mode == .select) && (group.id == selectedGroupID) {
			cell.accessoryType = .checkmark
		} else {
			cell.accessoryType = .none
		}
		return cell
	}

	override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
		guard sourceIndexPath.row != destinationIndexPath.row else {
			return
		}
		// TODO: Finish this.
	}

	override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
		guard documentHandler.getDocument().groups[indexPath.row].id != NotSetGroupId else {
			return false
		}
		return true
	}

	override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
		let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") { (deleteAction, indexPath) in
			let document = self.documentHandler.getDocument()
			let groupToDelete = document.groups[indexPath.row]
			if document.hasCostSheetsInGroupWithId(groupToDelete.id) {
				self.showAlertForGroupDeletionConfirmation(deleteIndexPath: indexPath)
			} else {
				self.deleteGroup(at: indexPath)
			}
		}
		return [deleteAction]
	}

	private func deleteGroup(at indexPath: IndexPath) {
		let document = documentHandler.getDocument()
		documentHandler.deleteGroupAndMoveRelatedCostSheetsToDefaultGroup(index: indexPath.row)
		if indexPath.row > 0 {
			selectedGroupID = document.groups[indexPath.row - 1].id
		} else {
			selectedGroupID = document.groups[0].id
		}
		self.tableView.reloadData()
	}

	private func showAlertForGroupDeletionConfirmation(deleteIndexPath: IndexPath) {
		let document = documentHandler.getDocument()
		let deletionGroup = document.groups[deleteIndexPath.row]
		let costSheetCount = document.numberOfCostSheetsInGroupWithId(deletionGroup.id)

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
			self.deleteGroup(at: deleteIndexPath)
			alertController.dismiss(animated: true)
		}))
		present(alertController, animated: true)
	}

}

// MARK: UITableViewDelegate
extension GroupTableViewController {

	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		switch mode! {
		case .edit:
			tableView.deselectRow(at: indexPath, animated: true)
		case .select:
			let group = documentHandler.getDocument().groups[indexPath.row]
			selectedGroupID = group.id
			tableView.reloadData()
		}
	}

	private func renameGroup(at indexPath: IndexPath) {
		let groupToRename = documentHandler.getDocument().groups[indexPath.row]
		let alertController = UIAlertController(title: "Rename group", message: "Please enter a new name for \(groupToRename.name)", preferredStyle: .alert)
		alertController.addTextField { (textField) in
			textField.text = groupToRename.name
			textField.addTarget(self, action: #selector(self.renameAlertTextFieldTextDidChange), for: .editingChanged)
		}
		let cancelAction = UIAlertAction( title: "Cancel", style: .cancel, handler: { (cancelAction) in
			alertController.dismiss(animated: true)
		})
		renameGroupAlertOkAction = UIAlertAction(title: "Ok", style: .default, handler: { (okAction) in
			guard let textField = alertController.textFields?.first,
				let newName = textField.text else {
					assertionFailure()
					return
			}
			guard self.documentHandler.getDocument().isGroupNameNew(newName) else {
				self.showAlertSaying("\'\(newName)\' already exists. Please enter a different name.")
				return
			}
			self.documentHandler.renameGroupAt(indexPath.row, to: newName)
			self.tableView.reloadRows(at: [indexPath], with: .automatic)
			alertController.dismiss(animated: true)
		})
		alertController.addAction(cancelAction)
		alertController.addAction(renameGroupAlertOkAction!)
		present(alertController, animated: true)
	}

	@objc
	func renameAlertTextFieldTextDidChange(textField: UITextField) {
		guard let renameGroupAlertOkAction = renameGroupAlertOkAction else {
			assertionFailure()
			return
		}
		if textField.text == "" {
			renameGroupAlertOkAction.isEnabled = false
		} else {
			renameGroupAlertOkAction.isEnabled = true
		}
	}

}

// MARK: IBActions
private extension GroupTableViewController {

	@IBAction func createGroupButtonPressed(_ sender: Any) {
		let alertController = UIAlertController(title: "New Group", message: "Please enter a group name.", preferredStyle: .alert)
		alertController.addTextField { (textField) in
			textField.placeholder = "Group Name"
			textField.addTarget(self, action: #selector(self.nameAlertTextFieldTextDidChange), for: .editingChanged)
		}
		let cancelAction = UIAlertAction( title: "Cancel", style: .cancel, handler: { (cancelAction) in
			alertController.dismiss(animated: true)
		})
		createGroupAlertOkAction = UIAlertAction(title: "Ok", style: .default, handler: { (okAction) in
			guard let textField = alertController.textFields?.first,
				let groupName = textField.text else {
					assertionFailure()
					return
			}
			guard self.documentHandler.getDocument().isGroupNameNew(groupName) else {
				self.showAlertSaying("\'\(groupName)\' already exists. Please enter a different name.")
				return
			}
			self.documentHandler.insertGroupWithName(groupName)
			self.selectedGroupID = self.documentHandler.getDocument().groups.last!.id
			self.tableView.reloadData()
			alertController.dismiss(animated: true)
		})
		createGroupAlertOkAction?.isEnabled = false
		alertController.addAction(cancelAction)
		alertController.addAction(createGroupAlertOkAction!)
		present(alertController, animated: true)
	}

	@objc
	func nameAlertTextFieldTextDidChange(textField: UITextField) {
		guard let alertOkAction = createGroupAlertOkAction else {
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
