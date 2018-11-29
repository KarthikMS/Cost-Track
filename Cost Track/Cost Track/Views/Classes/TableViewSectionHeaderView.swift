//
//  TableViewSectionHeaderView.swift
//  Cost Track
//
//  Created by Karthik M S on 26/08/18.
//  Copyright © 2018 Karthik M S. All rights reserved.
//

import UIKit

protocol TableViewSectionHeaderViewDelegate: class {
	func sectionHeaderViewTapped(section: Int)
}

class TableViewSectionHeaderView: UIView {

	// MARK: Properties
	private let section: Int
	weak var delegate: TableViewSectionHeaderViewDelegate?

	// MARK: Initializers
	init(frame: CGRect, section: Int, text: String, balance: Float?, delegate: TableViewSectionHeaderViewDelegate) {
		self.section = section
		self.delegate = delegate
		super.init(frame: frame)

		self.backgroundColor = TintedWhiteColor

		// Label
		let leftGap: CGFloat = 30
		var labelFrame = frame
		labelFrame.origin.x = leftGap
		labelFrame.size.width = 0.65 * frame.width//frame.width - labelFrame.origin.x
		let label = UILabel(frame: labelFrame)
		label.backgroundColor = .clear
		label.text = text
		label.font = UIFont.boldSystemFont(ofSize: 15)
		addSubview(label)

		// Balance label
		if var balance = balance {
			labelFrame.size.width = 0.1 * frame.width
			labelFrame.origin.x = frame.width - labelFrame.width - leftGap
			let balanceLabel = UILabel(frame: labelFrame)
			balanceLabel.font = UIFont.systemFont(ofSize: UIFont.smallSystemFontSize)
			balanceLabel.backgroundColor = .clear
			if balance < 0 {
				balanceLabel.textColor = DarkExpenseColor
			} else {
				balanceLabel.textColor = DarkIncomeColor
			}
			if balance < 0 {
				balance *= -1
			}
			balanceLabel.text = String(balance)
			addSubview(balanceLabel)
		}

		// Tap gesture
		let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
		addGestureRecognizer(tapGesture)
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: Actions
	@objc
	private func viewTapped() {
		guard let delegate = delegate else {
			assertionFailure()
			return
		}
		delegate.sectionHeaderViewTapped(section: section)
	}

}
