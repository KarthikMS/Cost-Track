//
//  MyCostSheetsViewController.swift
//  Cost Track
//
//  Created by Karthik M S on 14/07/18.
//  Copyright © 2018 Karthik M S. All rights reserved.
//

import UIKit

class MyCostSheetsViewController: UIViewController {

	// MARK: IBOutlets
	@IBOutlet weak var totalAmountLabel: UILabel!
	
	// MARK: UIViewController functions
    override func viewDidLoad() {
        super.viewDidLoad()

    }

}

// MARK: IBActions
extension MyCostSheetsViewController {

	@IBAction func chartViewButtonPressed(_ sender: Any) {
		print("ChartView")
	}

	@IBAction func generalStatisticsButtonPressed(_ sender: Any) {
		print("StatsView")
	}

}
