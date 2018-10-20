//
//  TransferAmountViewController.swift
//  Cost Track
//
//  Created by Karthik M S on 22/09/18.
//  Copyright © 2018 Karthik M S. All rights reserved.
//

import UIKit

protocol TransferAmountViewControllerDataSource: class {
	var document: Document { get }
	var selectedCostSheetId: String { get }
}

class TransferAmountViewController: UIViewController {

	// MARK: IBOutlets
	@IBOutlet private weak var amountTextView: UITextView!
	@IBOutlet private weak var receiveFromLabel: UILabel!
	@IBOutlet private weak var sourceCostSheetLabel: UILabel!
	@IBOutlet private weak var amountInLabel: UILabel!
	@IBOutlet private weak var sourceCostSheetBalanceLabel: UILabel!
	@IBOutlet weak var costSheetPickerView: UIPickerView!

	// MARK: Properties
	weak var dataSource: TransferAmountViewControllerDataSource?
	weak var deltaDelegate: DeltaDelegate?
	private var entryType = EntryType.expense
	private var sourceCostSheet = CostSheet()
	private var destinationCostSheetId = ""
	private var sourceCostSheets = [CostSheet]()

    override func viewDidLoad() {
        super.viewDidLoad()
		guard let dataSource = dataSource else {
			assertionFailure()
			return
		}

		switch entryType {
		case .expense:
			break
		case .income:
			break
		}

		sourceCostSheets = dataSource.document.costSheets.filter{ $0.id != dataSource.selectedCostSheetId }
		sourceCostSheet = sourceCostSheets[0]
		updateViews()
    }

	// MARK: View functions
	private func updateViews() {
		sourceCostSheetLabel.text = sourceCostSheet.name
		amountInLabel.text = "Amount in \(sourceCostSheet.name)"
		sourceCostSheetBalanceLabel.text = String(sourceCostSheet.balance)
	}

}

// MARK: IBActions
private extension TransferAmountViewController {

	@IBAction func cancelButtonPressed(_ sender: Any) {
		navigationController?.popViewController(animated: true)
	}

	@IBAction func saveButtonPressed(_ sender: Any) {
		guard let amount = Float(amountTextView.text),
			amount > 0 else {
				// TODO: Show alert to enter amount > 0
				return
		}
		
		navigationController?.popViewController(animated: true)
	}

}

// MARK: UIPickerViewDataSource
extension TransferAmountViewController: UIPickerViewDataSource {

	func numberOfComponents(in pickerView: UIPickerView) -> Int {
		return 1
	}

	func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		return sourceCostSheets.count
	}

}

// MARK: UIPickerViewDelegate
extension TransferAmountViewController: UIPickerViewDelegate {

	func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		return sourceCostSheets[row].name
	}

	func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
		sourceCostSheet = sourceCostSheets[row]
		updateViews()
	}

}
