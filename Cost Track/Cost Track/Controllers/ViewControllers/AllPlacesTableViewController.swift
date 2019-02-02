//
//  AllPlacesTableViewController.swift
//  Cost Track
//
//  Created by Karthik M S on 01/12/18.
//  Copyright © 2018 Karthik M S. All rights reserved.
//

import UIKit

enum AllPlacesTableViewControllerMode {
	case view
	case select
}

protocol PlaceSelectionDelegate: class {
	func didSelectPlace(withId placeId: String)
}

class AllPlacesTableViewController: UITableViewController {

	// MARK: Global parameters
	private weak var documentHandler: DocumentHandler!
	private weak var placeSelectionDelegate: PlaceSelectionDelegate?
	private var newPlaceAlertOkAction: UIAlertAction?
	private var renamePlaceAlertOkAction: UIAlertAction?
	private var mode = AllPlacesTableViewControllerMode.view
	private var selectedPlaceId: String?

	func setup(documentHandler: DocumentHandler, placeSelectionDelegate: PlaceSelectionDelegate?, selectedPlaceId: String? = nil, mode: AllPlacesTableViewControllerMode) {
		self.documentHandler = documentHandler
		self.placeSelectionDelegate = placeSelectionDelegate
		self.selectedPlaceId = selectedPlaceId
		self.mode = mode
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
		return documentHandler.getDocument().places.count
	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "AllPlacesTableViewCell", for: indexPath)
		let place = documentHandler.getDocument().places[indexPath.row]
		if let selectedPlaceId = selectedPlaceId, place.id == selectedPlaceId {
			cell.accessoryType = .checkmark
		} else {
			cell.accessoryType = .none
		}
		cell.textLabel?.text = place.name
		return cell
	}

	override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
		switch mode {
		case .view:
			return true
		case .select:
			return false
		}
	}

	override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
		let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") { (deleteAction, indexPath) in
			let document = self.documentHandler.getDocument()
			let placeToDelete = document.places[indexPath.row]
			if document.hasEntriesWithPlaceId(placeToDelete.id) {
				self.showAlertForPlaceDeletionConfirmation(indexPath: indexPath)
			} else {
				self.deletePlace(at: indexPath)
			}
		}
		return [deleteAction]
	}

	private func deletePlace(at indexPath: IndexPath) {
		documentHandler.deletePlaceAndClearRelatedPlaceIds(index: indexPath.row)
		tableView.reloadData()
	}

	private func showAlertForPlaceDeletionConfirmation(indexPath: IndexPath) {
		let document = documentHandler.getDocument()
		let placeToDelete = document.places[indexPath.row]
		let entryCount = document.entriesWithPlaceId(placeToDelete.id).count

		let message: String
		if entryCount == 1 {
			message = "There is an entry with place \(placeToDelete.name). It will NOT be deleted. It's place will be cleared.'"
		} else {
			message = "There are \(entryCount) entries with place \(placeToDelete.name). They will NOT be deleted. Their places will be cleared."
		}

		let alertController = UIAlertController(title: "Delete Place", message: message, preferredStyle: .alert)
		alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (cancelAction) in
			alertController.dismiss(animated: true)
		}))
		alertController.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { (deleteAction) in
			self.deletePlace(at: indexPath)
			alertController.dismiss(animated: true)
		}))
		present(alertController, animated: true)
	}

}

// MARK: UITableViewDelegate
extension AllPlacesTableViewController {

	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
		switch mode {
		case .view:
			showAlertToRenamePlace(at: indexPath.row)
		case .select:
			let selectedPlace = documentHandler.getDocument().places[indexPath.row]
			placeSelectionDelegate?.didSelectPlace(withId: selectedPlace.id)
			navigationController?.popViewController(animated: true)
		}
	}

	private func showAlertToRenamePlace(at index: Int) {
		let document = documentHandler.getDocument()
		let place = document.places[index]
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

			// TODO: Modify condition to take into account address.
			guard document.isPlaceNameNew(newPlaceName) else {
				self.showAlertSaying("\'\(newPlaceName)\' already exists. Please enter a different name.")
				return
			}

			// Updated place
			var updatedPlace = place
			updatedPlace.name = newPlaceName
			self.documentHandler.updatePlace(at: index, with: updatedPlace)

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
			let document = self.documentHandler.getDocument()

			guard document.isPlaceNameNew(placeName) else {
				self.showAlertSaying("\'\(placeName)\' already exists. Please enter a different name.")
				return
			}

			self.documentHandler.insertPlaceWithName(placeName)

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
