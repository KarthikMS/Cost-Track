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
		dateFormatter.amSymbol = "AM"
		dateFormatter.pmSymbol = "PM"
		return dateFormatter.string(from: self)
	}

	// TODO: Study this function
	func startAndEndDatesOfWeek() -> (startDate: Date, endDate: Date) {
		let calendar = Calendar.current
		guard let sunday = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)),
			let startDate = calendar.date(byAdding: .day, value: 0, to: sunday),
			let endDate = calendar.date(byAdding: .day, value: 6, to: sunday) else {
				assertionFailure("Could not get dates")
				return (Date(), Date())
		}
		return (startDate, endDate)
	}

	func startAndEndDatesAMonthApart(startDay: Int) -> (startDate: Date, endDate: Date) {
		let calendar = Calendar.current
		var dateComponents = calendar.dateComponents([.month, .year], from: self)
		dateComponents.day = startDay
		guard let today = calendar.dateComponents([.day], from: self).day,
			var tempDate = calendar.date(from: dateComponents) else {
				return (Date(), Date())
		}

		let startDate, endDate: Date!
		if today >= startDay {
			startDate = tempDate
		} else {
			startDate = calendar.date(byAdding: .month, value: -1, to: tempDate)
		}
		tempDate = calendar.date(byAdding: .month, value: 1, to: startDate)!
		endDate = calendar.date(byAdding: .day, value: -1, to: tempDate)
		return (startDate, endDate)
	}

}

extension Data {

	var date: Date? {
		return NSKeyedUnarchiver.unarchiveObject(with: self) as? Date
	}

}
