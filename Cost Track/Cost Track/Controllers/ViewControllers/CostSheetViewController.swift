//
//  CostSheetViewController.swift
//  Cost Track
//
//  Created by Karthik M S on 15/07/18.
//  Copyright © 2018 Karthik M S. All rights reserved.
//

import UIKit

class CostSheetViewController: UIViewController {

	// MARK: IBOutlets
	@IBOutlet weak var transactionsTableView: UITableView!

	// MARK: Properties
	let transactionsTableViewDataSource = TransactionsTableViewDataSource()

	// MARK: UIViewController functions
    override func viewDidLoad() {
        super.viewDidLoad()

		transactionsTableView.register(UINib(nibName: "TransactionsTableViewCell", bundle: nil), forCellReuseIdentifier: "TransactionsTableViewCell")
		transactionsTableView.dataSource = transactionsTableViewDataSource
    }

}

// MARK: IBActions
extension CostSheetViewController {

	@IBAction func expenseButtonPressed(_ sender: Any) {
		// Finish this
	}

	@IBAction func incomeButtonPressed(_ sender: Any) {
		// Finish this
	}

	@IBAction func classificationSegmentedControlValueChanged(_ sender: UISegmentedControl) {
		switch sender.selectedSegmentIndex {
		case 0:
			transactionsTableViewDataSource.mode = .date
		case 1:
			transactionsTableViewDataSource.mode = .category
		default:
			transactionsTableViewDataSource.mode = .place
		}
		transactionsTableView.reloadData()
	}

}

// MARK: UITableViewDelegate
extension CostSheetViewController: UITableViewDelegate {

	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 80
	}

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		performSegue(withIdentifier: "CostSheetEntrySegue", sender: nil)
	}

}
