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

	func startAndEndDatesOfYear() -> (startDate: Date, endDate: Date) {
		let dateFormatter = DateFormatter()
		let year = self.string(format: "yyyy")
		let startDate = dateFormatter.date(from: "01 01 \(year)")!
		let endDate = dateFormatter.date(from: "31 12 \(year)")!
		return (startDate, endDate)
	}

	func isBetween(_ startDate: Date, and endDate: Date) -> Bool {
		let day = self.string(format: "dd")
		let month = self.string(format: "MM")
		let year = self.string(format: "yyyy")

		let startDay = startDate.string(format: "dd")
		let startMonth = startDate.string(format: "MM")
		let startYear = startDate.string(format: "yyyy")

		var afterStartDate = false
		if year >= startYear {
			if month > startMonth {
				afterStartDate = true
			} else if month == startMonth {
				if day >= startDay {
					afterStartDate = true
				}
			}
		}
		guard afterStartDate else {
			return false
		}

		let endDay = endDate.string(format: "dd")
		let endMonth = endDate.string(format: "MM")
		let endYear = endDate.string(format: "yyyy")

		var beforeEndDate = false
		if year <= endYear {
			if month < endMonth {
				beforeEndDate = true
			} else if month == endMonth {
				if day <= endDay {
					beforeEndDate = true
				}
			}
		}

		return beforeEndDate
	}
	
}

extension Data {

	var date: Date? {
		return NSKeyedUnarchiver.unarchiveObject(with: self) as? Date
	}

}
