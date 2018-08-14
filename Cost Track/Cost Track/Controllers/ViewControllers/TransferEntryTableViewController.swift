//
//  TransferEntryTableViewController.swift
//  Cost Track
//
//  Created by Karthik M S on 14/08/18.
//  Copyright © 2018 Karthik M S. All rights reserved.
//

import UIKit

protocol TransferEntryTableViewControllerDataSource: class {
	var filteredCostSheets: [CostSheet] {get}
}

protocol TransferEntryTableViewControllerDelegate: class {
	func transferCostSheetEntry(_ costSheetEntry: CostSheetEntry, to toCostSheet: CostSheet)
}

class TransferEntryTableViewController: UITableViewController {

	// MARK: IBOutlets
	@IBOutlet weak var transferButton: UIBarButtonItem!

	// MARK: Properties
	weak var dataSource: TransferEntryTableViewControllerDataSource?
	weak var delegate: TransferEntryTableViewControllerDelegate?

	// MARK: UIViewController functions
    override func viewDidLoad() {
        super.viewDidLoad()

    }

}

// MARK: UITableViewDataSource
extension TransferEntryTableViewController {

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		guard let dataSource = dataSource else {
			assertionFailure()
			return 0
		}
		return dataSource.filteredCostSheets.count
	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "TransferEntryCell", for: indexPath)
		guard let dataSource = dataSource else {
			assertionFailure()
			return cell
		}
		cell.textLabel?.text = "\(dataSource.filteredCostSheets[indexPath.row].name)"
		return cell
	}

}

// MARK: UITableViewDelegate
extension TransferEntryTableViewController {

	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

	}

}

// MARK: IBActions
extension TransferEntryTableViewController {

	@IBAction func transferButtonPressed(_ sender: Any) {
	}

	@IBAction func cancelButtonPressed(_ sender: Any) {
		dismiss(animated: true, completion: nil)
	}

}
