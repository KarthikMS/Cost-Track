//
//  NewCostSheetViewController.swift
//  Cost Track
//
//  Created by Karthik M S on 15/07/18.
//  Copyright © 2018 Karthik M S. All rights reserved.
//

import UIKit

class NewCostSheetViewController: UIViewController {

	// MARK: IBOutlets
	@IBOutlet weak var settingsTableView: CostSheetSettingsTableView!

	// MARK: UIViewController functions
    override func viewDidLoad() {
        super.viewDidLoad()

		settingsTableView.setMode(.newCostSheet)
    }

}
