//
//  SettingsTableViewController.swift
//  Cost Track
//
//  Created by Karthik M S on 02/10/18.
//  Copyright © 2018 Karthik M S. All rights reserved.
//

import UIKit

// MARK: Protocols
protocol SettingsTableViewControllerDelegate: class {
	func refreshView()
}

// MARK: Constants
private let ClearDataSection = 0

class SettingsTableViewController: UITableViewController {

	// MARK: Properties
	private weak var settingsTableViewControllerDelegate: SettingsTableViewControllerDelegate!
	func setup(delegate: SettingsTableViewControllerDelegate) {
		self.settingsTableViewControllerDelegate = delegate
	}

	// MARK: UIViewController functions
    override func viewDidLoad() {
        super.viewDidLoad()

    }

	// MARK: View functions
	private func showActionSheetToClearData() {
		let actionSheet = UIAlertController(title: nil, message: "Are you sure you want to clear all data?", preferredStyle: .actionSheet)
		let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { (deletAction) in
			CTFileManager.deleteDocument()
			self.settingsTableViewControllerDelegate.refreshView()
		}
		let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (cancelAction) in
			actionSheet.dismiss(animated: true)
		}
		actionSheet.addAction(deleteAction)
		actionSheet.addAction(cancelAction)
		present(actionSheet, animated: true)
	}

}

// MARK: UITableViewControllerDataSource
extension SettingsTableViewController {

	override func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 1
	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsTableViewCellIdentifier", for: indexPath)
		switch indexPath.section {
		case ClearDataSection:
			cell.textLabel?.text = "Clear data"
		default:
			assertionFailure()
			break
		}
		return cell
	}

}

// MARK: UITableViewControllerDelegate
extension SettingsTableViewController {

	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		switch indexPath.section {
		case ClearDataSection:
			showActionSheetToClearData()
		default:
			assertionFailure()
			break
		}
		tableView.deselectRow(at: indexPath, animated: true)
	}

}
