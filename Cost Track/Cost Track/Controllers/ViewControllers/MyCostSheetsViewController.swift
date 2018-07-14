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
	@IBOutlet weak var tableView: UITableView!

	// MARK: UIViewController functions
    override func viewDidLoad() {
        super.viewDidLoad()

		tableView.register(UINib(nibName: "CostSheetTableViewCell", bundle: nil), forCellReuseIdentifier: "CostSheetTableViewCell")
    }

}

// MARK: IBActions
extension MyCostSheetsViewController {

	@IBAction func chartViewButtonPressed(_ sender: Any) {
		// Finish this
	}

	@IBAction func generalStatisticsButtonPressed(_ sender: Any) {
		// Finish this
	}

	@IBAction func addNewCostSheetButtonPressed(_ sender: Any) {
		// Finish this
	}

	@IBAction func settingsButtonPressed(_ sender: Any) {
		// Finish this
	}

	@IBAction func searchButtonPressed(_ sender: Any) {
		// Finish this
	}

}

// MARK: UITableViewDataSource
extension MyCostSheetsViewController: UITableViewDataSource {

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 2
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "CostSheetTableViewCell", for: indexPath) as! CostSheetTableViewCell
		
		// Finish this
		return cell
	}

}

// MARK: UITableViewDelegate
extension MyCostSheetsViewController: UITableViewDelegate {

	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 70
	}

}
