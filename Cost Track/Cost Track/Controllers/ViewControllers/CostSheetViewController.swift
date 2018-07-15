//
//  CostSheetViewController.swift
//  Cost Track
//
//  Created by Karthik M S on 15/07/18.
//  Copyright © 2018 Karthik M S. All rights reserved.
//

import UIKit

class CostSheetViewController: UIViewController {

	// MARK: UIViewController functions
    override func viewDidLoad() {
        super.viewDidLoad()
		
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

// MARK: IBActions
extension CostSheetViewController {

	@IBAction func expenseButtonPressed(_ sender: Any) {
		// Finish this
	}

	@IBAction func incomeButtonPressed(_ sender: Any) {
		// Finish this
	}

	@IBAction func classificationSegmentedControlValueChanged(_ sender: UISegmentedControl) {
		switch sender.selectedSegmentIndex {
		case 0:
			print("Date")
		case 1:
			print("Category")
		default:
			print("Place")
		}
	}

}
