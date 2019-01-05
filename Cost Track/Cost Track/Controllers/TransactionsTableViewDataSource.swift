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
		return dataSource.sortedEntriesForTableView.count
	}

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		guard let dataSource = dataSource else {
			assertionFailure()
			return 0
		}
		if dataSource.sectionsToHide.contains(section) {
			return 0
		}

		guard let entries = dataSource.sortedEntriesForTableView[section] else {
			assertionFailure("dataSource not set")
			return -1
		}
		return Array(entries)[0].value.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionsTableViewCell", for: indexPath) as! TransactionsTableViewCell
		guard let dataSource = dataSource,
			let costSheetEntry = dataSource.getSortedEntry(at: indexPath),
			let entryDate = costSheetEntry.date.date else {
				assertionFailure()
				return cell
		}

		let entryDescription: String?
		if costSheetEntry.hasDescription_p {
			entryDescription = costSheetEntry.description_p
		} else {
			entryDescription = nil
		}

		var placeName: String?
		if costSheetEntry.hasPlaceID {
			guard let place = dataSource.document.getPlace(withId: costSheetEntry.placeID) else {
				assertionFailure()
				return cell
			}
			placeName = place.name
		}

		cell.setAmount(costSheetEntry.amount,
					   entryType: costSheetEntry.type,
					   date: entryDate.string(format: "dd/MM/yy"),
					   time: entryDate.string(format: "hh:mm a"),
					   category: costSheetEntry.category.name,
					   place: placeName,
					   description: entryDescription,
					   forMode: dataSource.classificationMode
		)
		return cell
	}

	func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
		return true
	}

}
