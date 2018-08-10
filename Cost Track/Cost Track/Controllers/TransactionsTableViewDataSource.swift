//
//  TransactionsTableViewDataSource.swift
//  Cost Track
//
//  Created by Karthik M S on 15/07/18.
//  Copyright © 2018 Karthik M S. All rights reserved.
//

import UIKit

class TransactionsTableViewDataSource: NSObject {

	// MARK: Properties
	weak var dataSource: CostSheetViewController?

}

extension TransactionsTableViewDataSource: UITableViewDataSource {

	func numberOfSections(in tableView: UITableView) -> Int {
		guard let dataSource = dataSource else {
			assertionFailure("dataSource not set")
			return -1
		}
		switch dataSource.classificationMode {
		case .date:
			return dataSource.sortedEntries.count
		default:
			return 1
		}
		return 1
	}

	func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		guard let dataSource = dataSource,
		let entries = dataSource.sortedEntries[section] else {
			assertionFailure("dataSource not set")
			return nil
		}
		return Array(entries)[0].key
	}

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		guard let dataSource = dataSource,
		let entries = dataSource.sortedEntries[section] else {
			assertionFailure("dataSource not set")
			return -1
		}
		return Array(entries)[0].value.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionsTableViewCell", for: indexPath) as! TransactionsTableViewCell
//		guard let dataSource = dataSource,
//		let entries = dataSource.sortedEntries[indexPath.section] else {
//			assertionFailure("dataSource not set")
//			return cell
//		}
//		let costSheetEntry = Array(entries)[0].value[indexPath.row]
		guard let dataSource = dataSource,
			let costSheetEntry = dataSource.getSortedEntry(at: indexPath) else {
				assertionFailure()
				return cell
		}
		guard let entryDate = costSheetEntry.date.date else {
			assertionFailure()
			return cell
		}
		// Fix this
		cell.setAmount(costSheetEntry.amount,
					   date: entryDate,
					   time: "NIP",
					   category: costSheetEntry.category.name,
					   place: costSheetEntry.place,
					   description: costSheetEntry.description_p,
					   forMode: dataSource.classificationMode
		)
		return cell
	}

}
