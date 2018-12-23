//
//  TransactionsTableViewCell.swift
//  Cost Track
//
//  Created by Karthik M S on 15/07/18.
//  Copyright © 2018 Karthik M S. All rights reserved.
//

import UIKit

class TransactionsTableViewCell: UITableViewCell {

	// MARK: IBOutlets
	@IBOutlet weak var amountLabel: UILabel!
	@IBOutlet weak var descriptionLabel: UILabel!
	
	@IBOutlet weak var dateMiddleView: UIView!
	@IBOutlet weak var DTimeLabel: UILabel!
	@IBOutlet weak var DPlaceLabel: UILabel!
	@IBOutlet weak var dateTopRightView: UIView!
	@IBOutlet weak var DCategoryLabel: UILabel!

	@IBOutlet weak var categoryMiddleView: UIView!
	@IBOutlet weak var CPlaceLabel: UILabel!
	@IBOutlet weak var categoryTopRightView: UIView!
	@IBOutlet weak var CTimeLabel: UILabel!
	@IBOutlet weak var CDateLabel: UILabel!
	
	@IBOutlet weak var placeMiddleView: UIView!
	@IBOutlet weak var PTimeLabel: UILabel!
	@IBOutlet weak var PDateLabel: UILabel!
	@IBOutlet weak var placeTopRightView: UIView!
	@IBOutlet weak var PCategoryLabel: UILabel!

	// MARK: Functions
	func setAmount(_ amount: Float, entryType: EntryType, date: String, time: String, category: String, place: String?, description: String?, forMode mode: TransactionClassificationMode) {
		setClassificationMode(mode)

		amountLabel.text = String(amount)
		switch entryType {
		case .income:
			amountLabel.textColor = DarkIncomeColor
		case .expense:
			amountLabel.textColor = DarkExpenseColor
		}
		
		if let description = description {
			descriptionLabel.text = description
		} else {
			descriptionLabel.text = ""
		}

		let placeName: String
		if let place = place {
			placeName = place
		} else {
			placeName = "No place"
		}

		switch mode {
		case .date:
			DTimeLabel.text = time
			DPlaceLabel.text = placeName
			DCategoryLabel.text = category
		case .category:
			CPlaceLabel.text = placeName
			CTimeLabel.text = time + ","
			CDateLabel.text = date
		case .place:
			PTimeLabel.text = time + ","
			PDateLabel.text = date
			PCategoryLabel.text = category
		}
	}

	private func setClassificationMode(_ mode: TransactionClassificationMode) {
		switch mode {
		case .date:
			dateMiddleView.isHidden = false
			dateTopRightView.isHidden = false
			categoryMiddleView.isHidden = true
			categoryTopRightView.isHidden = true
			placeMiddleView.isHidden = true
			placeTopRightView.isHidden = true
		case .category:
			dateMiddleView.isHidden = true
			dateTopRightView.isHidden = true
			categoryMiddleView.isHidden = false
			categoryTopRightView.isHidden = false
			placeMiddleView.isHidden = true
			placeTopRightView.isHidden = true
		case .place:
			dateMiddleView.isHidden = true
			dateTopRightView.isHidden = true
			categoryMiddleView.isHidden = true
			categoryTopRightView.isHidden = true
			placeMiddleView.isHidden = false
			placeTopRightView.isHidden = false
		}
	}
	
}
