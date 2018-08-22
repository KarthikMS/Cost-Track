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
	}

}
