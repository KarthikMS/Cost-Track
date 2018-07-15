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

}

extension TransactionsTableViewDataSource: UITableViewDataSource {

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 1
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionsTableViewCell", for: indexPath)

		return cell
	}

}
