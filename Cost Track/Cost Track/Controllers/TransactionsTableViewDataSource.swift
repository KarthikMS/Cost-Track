//
//  TransactionsTableViewDataSource.swift
//  Cost Track
//
//  Created by Karthik M S on 15/07/18.
//  Copyright © 2018 Karthik M S. All rights reserved.
//

import UIKit

enum TransactionClassification {
	case date
	case category
	case place
}

class TransactionsTableViewDataSource: NSObject {

	// MARK: Properties
	var mode = TransactionClassification.date
	var costSheet = CostSheet()

}

extension TransactionsTableViewDataSource: UITableViewDataSource {

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 2
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionsTableViewCell", for: indexPath) as! TransactionsTableViewCell

		// This is just to check
		let costSheetEntry = costSheet.entries[indexPath.row]
		let categoryStringTest = String(describing: costSheetEntry.category)
		cell.setAmount(costSheetEntry.amount,
					   date: costSheetEntry.date,
					   time: "NIP",
					   category: categoryStringTest,
					   place: costSheetEntry.palce,
					   description: costSheetEntry.description_p,
					   forMode: .date
		)
		return cell
	}

}
