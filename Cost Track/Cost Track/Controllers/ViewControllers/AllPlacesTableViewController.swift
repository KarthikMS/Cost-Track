//
//  AllPlacesTableViewController.swift
//  Cost Track
//
//  Created by Karthik M S on 01/12/18.
//  Copyright © 2018 Karthik M S. All rights reserved.
//

import UIKit

class AllPlacesTableViewController: UITableViewController {

	// MARK: Global parameters
	private weak var settingsDataSource: SettingsDataSource!
	private weak var deltaDelegate: DeltaDelegate!
	private var newPlaceAlertOkAction: UIAlertAction?

	func setup(dataSource: SettingsDataSource, deltaDelegate: DeltaDelegate) {
		self.settingsDataSource = dataSource
		self.deltaDelegate = deltaDelegate
	}

}

// MARK: UIViewController
extension AllPlacesTableViewController {

	override func viewDidLoad() {
		super.viewDidLoad()

	}

}

// MARK: UITableViewDataSource
extension AllPlacesTableViewController {

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return settingsDataSource.document.places.count
	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "AllPlacesTableViewCell", for: indexPath)
		let place = settingsDataSource.document.places[indexPath.row]
		cell.textLabel?.text = place.name
		return cell
	}

}

// MARK: UITableViewDelegate
extension AllPlacesTableViewController {

	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		// TODO: Show alert to rename place name
		tableView.deselectRow(at: indexPath, animated: true)
	}

}

// MARK: IBActions
extension AllPlacesTableViewController {

	@IBAction func addNewPlaceButtonPressed(_ sender: Any) {
		let alertController = UIAlertController(title: "New Place", message: "Please enter a place name.", preferredStyle: .alert)
		alertController.addTextField { (textField) in
			textField.placeholder = "Place Name"
			textField.addTarget(self, action: #selector(self.alertTextFieldTextDidChange(textField:)), for: .editingChanged)
		}
		let cancelAction = UIAlertAction( title: "Cancel", style: .cancel, handler: { (cancelAction) in
			alertController.dismiss(animated: true)
		})
		newPlaceAlertOkAction = UIAlertAction(title: "Ok", style: .default, handler: { (okAction) in
			guard let textField = alertController.textFields?.first,
				let placeName = textField.text else {
					assertionFailure()
					return
			}
			let document = self.settingsDataSource.document

			guard document.isPlaceNameNew(placeName) else {
				self.showAlertSaying("\'\(placeName)\' already exists. Please enter a different name.")
				return
			}

			// New group
			var newPlace = Place()
			newPlace.name = placeName
			newPlace.id = UUID().uuidString

			// Delta Component
			let insertPlaceComponent = DeltaUtil.getComponentToInsertPlace(newPlace, in: document)
			self.deltaDelegate.sendDeltaComponents([insertPlaceComponent])

			self.tableView.reloadData()
			alertController.dismiss(animated: true)
		})
		newPlaceAlertOkAction?.isEnabled = false
		alertController.addAction(cancelAction)
		alertController.addAction(newPlaceAlertOkAction!)
		present(alertController, animated: true)
	}

	@objc
	func alertTextFieldTextDidChange(textField: UITextField) {
		guard let alertOkAction = newPlaceAlertOkAction else {
			assertionFailure()
			return
		}
		if textField.text == "" {
			alertOkAction.isEnabled = false
		} else {
			alertOkAction.isEnabled = true
		}
	}

}
