//
//  SettingsTableViewController.swift
//  Cost Track
//
//  Created by Karthik M S on 02/10/18.
//  Copyright © 2018 Karthik M S. All rights reserved.
//

import UIKit

// MARK: Constants
private let ClearDataSection = 0
private let AllPlacesSection = 1

class SettingsTableViewController: UITableViewController {

	// MARK: Properties
	private weak var documentHandler: DocumentHandler!
	private weak var deltaDelegate: DeltaDelegate!
	func setup(documentHandler: DocumentHandler) {
		self.documentHandler = documentHandler
	}

	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		guard let identifier = segue.identifier else {
			return
		}
		switch identifier {
		case AllPlacesSegue:
			guard let allPlacesTableViewController = segue.destination as? AllPlacesTableViewController else {
				assertionFailure()
				return
			}
			allPlacesTableViewController.setup(documentHandler: documentHandler, placeSelectionDelegate: nil, mode: .view)
		default:
			return
		}
	}

	// MARK: View functions
	private func showActionSheetToClearData() {
		let actionSheet = UIAlertController(title: nil, message: "Are you sure you want to clear all data?", preferredStyle: .actionSheet)
		let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { (deletAction) in
			self.documentHandler.deleteDocument()
			UserDefaults.standard.setValue(true, forKey: BalanceCarryOver)
			UserDefaults.standard.setValue(1, forKey: StartDayForMonthlyAccountingPeriod)
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
		// Temp
		return 2
	}

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		// Temp
		return 1
	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsTableViewCellIdentifier", for: indexPath)
		switch indexPath.section {
		case ClearDataSection:
			cell.textLabel?.text = "Clear data"
		case AllPlacesSection:
			cell.textLabel?.text = "Places"
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
		case AllPlacesSection:
			performSegue(withIdentifier: AllPlacesSegue, sender: nil)
		default:
			assertionFailure()
			break
		}
		tableView.deselectRow(at: indexPath, animated: true)
	}

}
