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
	private let text: String
	weak var delegate: TableViewSectionHeaderViewDelegate?

	// MARK: Initializers
	init(frame: CGRect, section: Int, text: String, delegate: TableViewSectionHeaderViewDelegate) {
		self.section = section
		self.text = text
		self.delegate = delegate
		super.init(frame: frame)

		self.backgroundColor = TintedWhiteColor

		// Label
		let leftGap: CGFloat = 30
		var labelFrame = frame
		labelFrame.origin.x = leftGap
		labelFrame.size.width = frame.width - labelFrame.origin.x
		let label = UILabel(frame: labelFrame)
		label.backgroundColor = .clear
		label.text = text
		label.font = UIFont.boldSystemFont(ofSize: 15)
		addSubview(label)

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
