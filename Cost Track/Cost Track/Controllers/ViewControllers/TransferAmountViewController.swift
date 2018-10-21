//
//  TransferAmountViewController.swift
//  Cost Track
//
//  Created by Karthik M S on 22/09/18.
//  Copyright © 2018 Karthik M S. All rights reserved.
//

import UIKit

struct TransferAmountInfo {
	let amount: Float
	let transferCostSheet: CostSheet
	let entryTye: EntryType
}

protocol TransferAmountViewControllerDelegate: class {
	func transferSaved(transferAmountInfo: TransferAmountInfo)
	func transferCancelled()
}

class TransferAmountViewController: UIViewController {

	// MARK: IBOutlets
	@IBOutlet weak var navigationBarTitleButton: UIButton!
	@IBOutlet private weak var amountTextView: UITextView!
	@IBOutlet private weak var receiveFromLabel: UILabel!
	@IBOutlet private weak var transferCostSheetLabel: UILabel!
	@IBOutlet private weak var amountInLabel: UILabel!
	@IBOutlet private weak var transferCostSheetBalanceLabel: UILabel!
	@IBOutlet weak var transferCostSheetPickerView: UIPickerView!

	// MARK: Properties
	weak var delegate: TransferAmountViewControllerDelegate?

	var document: Document?
	var costSheetId: String?
	var entryType = EntryType.expense
	var amount: Float = 0

	private var transferCostSheet = CostSheet()
	private var transferCostSheets = [CostSheet]()

    override func viewDidLoad() {
		super.viewDidLoad()
		guard let document = document,
			let costSheetId = costSheetId else {
				assertionFailure()
				return
		}

		transferCostSheets = document.costSheets.filter{ $0.id != costSheetId }
		transferCostSheet = transferCostSheets[0]
		updateViews()
		updateViewsBasedOnEntryType()
		transferCostSheetLabel.layer.borderColor = UIColor.white.cgColor
		amountTextView.text = String(amount)
    }

	// MARK: View functions
	private func updateViews() {
		transferCostSheetLabel.text = transferCostSheet.name
		amountInLabel.text = "Amount in \(transferCostSheet.name)"
		transferCostSheetBalanceLabel.text = String(transferCostSheet.balance)
	}

	private func updateViewsBasedOnEntryType() {
		switch entryType {
		case .expense:
			navigationBarTitleButton.setTitle("Outgoing", for: .normal)
			navigationBarTitleButton.setTitleColor(DarkExpenseColor, for: .normal)
			amountTextView.backgroundColor = LightExpenseColor
			receiveFromLabel.text = "Send to:"
		case .income:
			navigationBarTitleButton.setTitle("Incoming", for: .normal)
			navigationBarTitleButton.setTitleColor(DarkIncomeColor, for: .normal)
			amountTextView.backgroundColor = LightIncomeColor
			receiveFromLabel.text = "Receive from:"
		}
	}

	private func showAlertForInvalidAmount() {
		let alertController = UIAlertController(title: nil, message: "Please enter an amount greater than 0", preferredStyle: .alert)
		let okAction = UIAlertAction(title: "Ok", style: .default) { (_) in
			alertController.dismiss(animated: true)
		}
		alertController.addAction(okAction)
		present(alertController, animated: true)
	}

}

// MARK: IBActions
private extension TransferAmountViewController {

	@IBAction func navigationBarTitleButtonPressed(_ sender: Any) {
		switch entryType {
		case .income:
			entryType = .expense
		case .expense:
			entryType = .income
		}
		updateViewsBasedOnEntryType()
	}

	@IBAction func cancelButtonPressed(_ sender: Any) {
		delegate?.transferCancelled()
		navigationController?.popViewController(animated: true)
	}

	@IBAction func saveButtonPressed(_ sender: Any) {
		guard let amount = Float(amountTextView.text),
			amount > 0,
			let delegate = delegate else {
				showAlertForInvalidAmount()
				return
		}

		let transferAmountInfo = TransferAmountInfo(amount: amount, transferCostSheet: transferCostSheet, entryTye: entryType)
		delegate.transferSaved(transferAmountInfo: transferAmountInfo)
		navigationController?.popViewController(animated: true)
	}

}

// MARK: UIPickerViewDataSource
extension TransferAmountViewController: UIPickerViewDataSource {

	func numberOfComponents(in pickerView: UIPickerView) -> Int {
		return 1
	}

	func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		return transferCostSheets.count
	}

}

// MARK: UIPickerViewDelegate
extension TransferAmountViewController: UIPickerViewDelegate {

	func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		return transferCostSheets[row].name
	}

	func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
		transferCostSheet = transferCostSheets[row]
		updateViews()
	}

}
