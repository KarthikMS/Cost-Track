//
//  GroupSelectTableViewController.swift
//  Cost Track
//
//  Created by Karthik M S on 22/08/18.
//  Copyright © 2018 Karthik M S. All rights reserved.
//

import UIKit

protocol GroupSelectTableViewControllerDataSource: class {
	var groups: [CostSheetGroup] { get }
}

protocol GroupSelectTableViewControllerDelegate: class {
	func didSelectGroup(id: String)
}

class GroupSelectTableViewController: UITableViewController {

	// MARK: Properties
	var selectedGroupID = ""
	weak var groupSelectTableViewControllerDataSource: GroupSelectTableViewControllerDataSource?
	weak var groupSelectTableViewControllerDelegate: GroupSelectTableViewControllerDelegate?
	private var alertOkAction: UIAlertAction?

	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)

		groupSelectTableViewControllerDelegate?.didSelectGroup(id: selectedGroupID)
	}

}

// MARK: UITableViewDataSource
extension GroupSelectTableViewController {

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		guard let groups = groupSelectTableViewControllerDataSource?.groups else {
			assertionFailure()
			return 0
		}
		return groups.count
	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "SelectGroupCell", for: indexPath)
		guard let group = groupSelectTableViewControllerDataSource?.groups[indexPath.row] else {
			assertionFailure()
			return cell
		}
		cell.textLabel?.text = group.name
		if group.id == selectedGroupID {
			cell.accessoryType = .checkmark
		} else {
			cell.accessoryType = .none
		}
		return cell
	}

}

// MARK: UITableViewDelegate
extension GroupSelectTableViewController {

	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		guard let group = groupSelectTableViewControllerDataSource?.groups[indexPath.row] else {
			assertionFailure()
			return
		}
		selectedGroupID = group.id
		tableView.reloadData()
	}

}

// MARK: IBActions
extension GroupSelectTableViewController {

	@IBAction func addGroupButtonPressed(_ sender: Any) {
		let alertController = UIAlertController(title: "New Group", message: "Please enter a group name.", preferredStyle: .alert)
		alertController.addTextField { (textField) in
			textField.placeholder = "Group Name"
			textField.addTarget(self, action: #selector(self.alertTextFieldTextDidChange(textField:)), for: .editingChanged)
		}
		let cancelAction = UIAlertAction( title: "Cancel", style: .cancel, handler: { (cancelAction) in
				alertController.dismiss(animated: true)
		})
		alertOkAction = UIAlertAction(title: "Ok", style: .default, handler: { (okAction) in
				alertController.dismiss(animated: true)
		})
		alertOkAction?.isEnabled = false
		alertController.addAction(cancelAction)
		alertController.addAction(alertOkAction!)
		present(alertController, animated: true)
	}

	@objc
	private func alertTextFieldTextDidChange(textField: UITextField) {
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
