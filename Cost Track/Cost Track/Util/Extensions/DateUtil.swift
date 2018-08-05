//
//  DateUtil.swift
//  Cost Track
//
//  Created by Karthik M S on 05/08/18.
//  Copyright © 2018 Karthik M S. All rights reserved.
//

import Foundation

extension Date {

	var data: Data {
		return NSKeyedArchiver.archivedData(withRootObject: self)
	}

	func string(format: String) -> String {
		let dateFormatter = DateFormatter()
		dateFormatter.locale = Locale.current
		dateFormatter.dateFormat = format
		return dateFormatter.string(from: self)
	}

}

extension Data {

	var date: Date? {
		return NSKeyedUnarchiver.unarchiveObject(with: self) as? Date
	}

}
