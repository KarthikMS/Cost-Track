//
//  TransferEntryTableViewController.swift
//  Cost Track
//
//  Created by Karthik M S on 14/08/18.
//  Copyright © 2018 Karthik M S. All rights reserved.
//

import UIKit

protocol TransferEntryTableViewControllerDataSource: class {
	var fromCostSheetId: String { get }
	var entryToTransferId: String { get }
	var document: Document { get }
}

class TransferEntryTableViewController: UITableViewController {

	// MARK: IBOutlets
	@IBOutlet weak var transferButton: UIBarButtonItem!

	// MARK: Properties
	private weak var dataSource: TransferEntryTableViewControllerDataSource!
	private weak var deltaDelegate: DeltaDelegate!
	func setup(dataSource: TransferEntryTableViewControllerDataSource, deltaDelegate: DeltaDelegate) {
		self.dataSource = dataSource
		self.deltaDelegate = deltaDelegate
	}
	private var filteredCostSheets = [CostSheet]()
	private var selectedIndexPath: IndexPath?

	// MARK: UIViewController functions
    override func viewDidLoad() {
        super.viewDidLoad()

		// Getting filteredCostSheets
		let fromCostSheetId = dataSource.fromCostSheetId
		let document = dataSource.document
		for costSheet in document.costSheets {
			if costSheet.id != fromCostSheetId {
				filteredCostSheets.append(costSheet)
			}
		}
    }

}

// MARK: UITableViewDataSource
extension TransferEntryTableViewController {

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return filteredCostSheets.count
	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "TransferEntryCell", for: indexPath)
		cell.textLabel?.text = "\(filteredCostSheets[indexPath.row].name)"
		if let selectedIndexPath = selectedIndexPath, selectedIndexPath == indexPath {
			cell.accessoryType = .checkmark
		}
		return cell
	}

}

// MARK: UITableViewDelegate
extension TransferEntryTableViewController {

	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		selectedIndexPath = indexPath
		transferButton.isEnabled = true
		tableView.reloadData()
	}

}

// MARK: IBActions
private extension TransferEntryTableViewController {

	@IBAction func transferButtonPressed(_ sender: Any) {
		guard let selectedIndexPath = selectedIndexPath else {
				assertionFailure()
				return
		}
		let entryId = dataSource.entryToTransferId
		let fromCostSheetId = dataSource.fromCostSheetId
		let toCostSheetId = filteredCostSheets[selectedIndexPath.row].id
		let document = dataSource.document
		let transferEntryComps = DeltaUtil.getComponentsToTransferEntry(withId: entryId, fromCostSheetWithId: fromCostSheetId, toCostSheetWithId: toCostSheetId, document: document)
		deltaDelegate.sendDeltaComponents(transferEntryComps)
		dismiss(animated: true, completion: nil)
	}

	@IBAction func cancelButtonPressed(_ sender: Any) {
		dismiss(animated: true, completion: nil)
	}

}
