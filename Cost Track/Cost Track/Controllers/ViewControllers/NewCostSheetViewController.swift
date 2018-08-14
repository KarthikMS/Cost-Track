//
//  NewCostSheetViewController.swift
//  Cost Track
//
//  Created by Karthik M S on 15/07/18.
//  Copyright © 2018 Karthik M S. All rights reserved.
//

import UIKit

protocol NewCostSheetViewControllerDataSource {
	var defaultCostSheetName: String { get }
}

protocol NewCostSheetViewControllerDelegate {
	func didCreateCostSheet(_ costSheet: CostSheet)
}

class NewCostSheetViewController: UIViewController {

	// MARK: IBOutlets
	@IBOutlet weak var settingsTableView: CostSheetSettingsTableView!

	// MARK: Properties
	var delegate: NewCostSheetViewControllerDelegate?
	var dataSource: NewCostSheetViewControllerDataSource?

	// MARK: UIViewController functions
    override func viewDidLoad() {
        super.viewDidLoad()

		settingsTableView.setMode(.newCostSheet)
    }

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		guard let dataSource = dataSource else {
			assertionFailure()
			return
		}

		settingsTableView.costSheetNameTextView.text = dataSource.defaultCostSheetName
		settingsTableView.initalBalanceTextView.text = "0.00"
	}
	
}

// MARK: IBActions
extension NewCostSheetViewController {

	@IBAction func createButtonPressed(_ sender: Any) {
		guard let costSheetName = settingsTableView.costSheetNameTextView.text,
			costSheetName != "",
			let initialBalance = Float(settingsTableView.initalBalanceTextView.text) else {
				// Show dialog to enter costSheet name

				return
		}
		var costSheet = CostSheet()
		costSheet.id = UUID().uuidString
		costSheet.name = costSheetName
		costSheet.initialBalance = initialBalance
		costSheet.lastModifiedDate = Date().data

		delegate?.didCreateCostSheet(costSheet)
		navigationController?.popViewController(animated: true)
	}

}
