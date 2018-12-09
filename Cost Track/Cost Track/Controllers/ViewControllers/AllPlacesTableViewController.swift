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
	private var renamePlaceAlertOkAction: UIAlertAction?

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
		showAlertToRenamePlace(at: indexPath.row)
		tableView.deselectRow(at: indexPath, animated: true)
	}

	private func showAlertToRenamePlace(at index: Int) {
		let place = settingsDataSource.document.places[index]
		let alertController = UIAlertController(title: "Rename Place", message: "Please enter a new name for \(place.name).", preferredStyle: .alert)
		alertController.addTextField { (textField: UITextField) in
			textField.placeholder = "New Name"
			textField.addTarget(self, action: #selector(self.renamePlaceAlertTextFieldTextDidChange), for: .editingChanged)
		}
		let cancelAction = UIAlertAction( title: "Cancel", style: .cancel, handler: { (cancelAction) in
			alertController.dismiss(animated: true)
		})
		renamePlaceAlertOkAction = UIAlertAction(title: "Ok", style: .default, handler: { (okAction) in
			guard let textField = alertController.textFields?.first,
				let newPlaceName = textField.text else {
					assertionFailure()
					return
			}
			let document = self.settingsDataSource.document

			guard document.isPlaceNameNew(newPlaceName) else {
				self.showAlertSaying("\'\(newPlaceName)\' already exists. Please enter a different name.")
				return
			}

			// Updated place
			var updatedPlace = place
			updatedPlace.name = newPlaceName

			// Delta Component
			let updatePlaceComponent = DeltaUtil.getComponentToUpdatePlace(updatedPlace, in: document, at: index)
			self.deltaDelegate.sendDeltaComponents([updatePlaceComponent])

			self.tableView.reloadData()
			alertController.dismiss(animated: true)
		})
		renamePlaceAlertOkAction?.isEnabled = false
		alertController.addAction(cancelAction)
		alertController.addAction(renamePlaceAlertOkAction!)
		present(alertController, animated: true)
	}

	@objc
	private func renamePlaceAlertTextFieldTextDidChange(textField: UITextField) {
		guard let alertOkAction = renamePlaceAlertOkAction else {
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

// MARK: IBActions
extension AllPlacesTableViewController {

	@IBAction func addNewPlaceButtonPressed(_ sender: Any) {
		let alertController = UIAlertController(title: "New Place", message: "Please enter a place name.", preferredStyle: .alert)
		alertController.addTextField { (textField: UITextField) in
			textField.placeholder = "Place Name"
			textField.addTarget(self, action: #selector(self.newPlaceAlertTextFieldTextDidChange), for: .editingChanged)
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

			// New place
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
	private func newPlaceAlertTextFieldTextDidChange(textField: UITextField) {
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
