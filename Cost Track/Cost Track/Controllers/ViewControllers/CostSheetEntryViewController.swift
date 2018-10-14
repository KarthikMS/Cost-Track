//
//  CostSheetEntryViewController.swift
//  Cost Track
//
//  Created by Karthik M S on 18/07/18.
//  Copyright © 2018 Karthik M S. All rights reserved.
//

import UIKit
import GooglePlacePicker

protocol CostSheetEntryViewControllerDataSource: class {
	var document: Document { get }
	var costSheetId: String { get }
}

class CostSheetEntryViewController: UIViewController {

	// MARK: IBOutlets
	// Views
	@IBOutlet weak var navigationBarTitleButton: UIButton!
	@IBOutlet weak var amountBarView: UIView!
	@IBOutlet weak var amountTextView: UITextView!
	@IBOutlet weak var categoryLabel: UILabel!
	@IBOutlet weak var dateLabel: UILabel!
	@IBOutlet weak var timeLabel: UILabel!
	@IBOutlet weak var selectPlaceLabel: UILabel!
	@IBOutlet weak var placeNameLabel: UILabel!
	@IBOutlet weak var placeAddressLabel: UILabel!
	@IBOutlet weak var descriptionTextView: UITextView!
	@IBOutlet weak var entryDatePicker: EntryDatePicker!
	@IBOutlet weak var entryCategoryPicker: EntryCategoryPicker!

	// Constraints
	@IBOutlet weak var categoryPickerHeightConstraint: NSLayoutConstraint!
	@IBOutlet weak var categoryPickerHideTopConstraint: NSLayoutConstraint!
	@IBOutlet weak var categoryPickerShowTopConstraint: NSLayoutConstraint!

	@IBOutlet weak var datePickerHeightConstraint: NSLayoutConstraint!
	@IBOutlet weak var datePickerHideTopConstraint: NSLayoutConstraint!
	@IBOutlet weak var datePickerShowTopConstraint: NSLayoutConstraint!

	@IBOutlet weak var placeEditorHeightConstraint: NSLayoutConstraint!
	@IBOutlet weak var placeEditorHideTopConstraint: NSLayoutConstraint!
	@IBOutlet weak var placeEditorShowTopConstraint: NSLayoutConstraint!

	// MARK: Properties
	weak var dataSource: CostSheetEntryViewControllerDataSource?
	weak var deltaDelegate: DeltaDelegate?
	var entryType = CostSheetEntry.EntryType.income
	var oldEntry: CostSheetEntry?
	private let locationManager = CLLocationManager()
	private var entryPlace: Place?

	// MARK: UIViewController functions
    override func viewDidLoad() {
        super.viewDidLoad()

		entryDatePicker.delegate = self
		entryCategoryPicker.delegate = self

		locationManager.distanceFilter = 50
		locationManager.desiredAccuracy = kCLLocationAccuracyBest
		locationManager.delegate = self

		if oldEntry != nil {
			updateViewsForOldEntry()
		} else {
			updateViewsToDefaultValues()
		}
    }

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)

		// Calculating height constraints for views in the bottom
		categoryPickerHeightConstraint.constant = view.frame.size.height - (descriptionTextView.frame.origin.y + descriptionTextView.frame.size.height)
		datePickerHeightConstraint.constant = categoryPickerHeightConstraint.constant
		placeEditorHeightConstraint.constant = categoryPickerHeightConstraint.constant
	}

	private func openPlacePicker() {
		requestLocationServicesIfNecessary()
		locationManager.startUpdatingLocation()
	}

	private func requestLocationServicesIfNecessary() {
		if CLLocationManager.locationServicesEnabled() {
			switch CLLocationManager.authorizationStatus() {
			case .notDetermined:
				locationManager.requestWhenInUseAuthorization()
			case .denied:
				showAlertToTakeUserToSettings()
			default:
				return
			}
		} else {
			showAlertToTakeUserToSettings()
		}
	}

	// MARK: View functions
	private func updateViewsForOldEntry() {
		guard let oldEntry = oldEntry,
			let oldEntryDate = oldEntry.date.date else {
				assertionFailure()
				return
		}
		entryType = oldEntry.type
		updateViewsBasedOnEntryType()
		amountTextView.text = String(oldEntry.amount)
		updateCategoryViews(category: oldEntry.category)
		updateDateViews(date: oldEntryDate)
		if oldEntry.hasPlace {
			entryPlace = oldEntry.place
			updatePlaceViews(place: oldEntry.place)
		} else {
			updatePlaceViews(place: nil)
		}
		descriptionTextView.text = oldEntry.description_p
	}

	private func updateViewsToDefaultValues() {
		updateViewsBasedOnEntryType()
		amountTextView.text = "0.00"
		updateCategoryViews(category: nil)
		updateDateViews(date: Date())
		descriptionTextView.text = "Description"
	}

	private func updateViewsBasedOnEntryType() {
		switch entryType {
		case .expense:
			navigationBarTitleButton.setTitle("Expense", for: .normal)
			navigationBarTitleButton.setTitleColor(LightExpenseColor, for: .normal)
			amountBarView.backgroundColor = LightExpenseColor
		case .income:
			navigationBarTitleButton.setTitle("Income", for: .normal)
			navigationBarTitleButton.setTitleColor(LightIncomeColor, for: .normal)
			amountBarView.backgroundColor = LightIncomeColor
		}
	}

	private func updateDateViews(date: Date) {
		if Calendar.current.isDateInToday(date) {
			dateLabel.text = "Today"
		} else {
			dateLabel.text = date.string(format: "dd-MMM-yyyy")
		}
		timeLabel.text = date.string(format: "hh:mm a")
		entryDatePicker.datePicker.date = date
	}

	private func updateCategoryViews(category: CostSheetEntry.Category?) {
		if let category = category {
			entryCategoryPicker.selectCategory(category)
		} else {
			entryCategoryPicker.categoryPickerView.selectRow(0, inComponent: 0, animated: false)
		}
		categoryLabel.text = entryCategoryPicker.selectedCategory.name
	}

	private func updatePlaceViews(place: Place?) {
		if let place = place {
			selectPlaceLabel.isHidden = true
			self.placeNameLabel.text = place.name
			self.placeAddressLabel.text = place.address
		} else {
			selectPlaceLabel.isHidden = false
		}
	}

	private func showCategoryPicker() {
		if categoryPickerShowTopConstraint.isActive {
			return
		}

		view.removeConstraint(categoryPickerHideTopConstraint)
		view.addConstraint(categoryPickerShowTopConstraint)
		UIView.animate(withDuration: 0.75) {
			self.view.layoutIfNeeded()
		}
	}

	private func hideCategoryPicker() {
		if categoryPickerHideTopConstraint.isActive {
			return
		}

		view.removeConstraint(categoryPickerShowTopConstraint)
		view.addConstraint(categoryPickerHideTopConstraint)
		UIView.animate(withDuration: 0.75) {
			self.view.layoutIfNeeded()
		}
	}

	private func showDatePicker() {
		if datePickerShowTopConstraint.isActive {
			return
		}

		view.removeConstraint(datePickerHideTopConstraint)
		view.addConstraint(datePickerShowTopConstraint)
		UIView.animate(withDuration: 0.75) {
			self.view.layoutIfNeeded()
		}
	}

	private func hideDatePicker() {
		if datePickerHideTopConstraint.isActive {
			return
		}

		view.removeConstraint(datePickerShowTopConstraint)
		view.addConstraint(datePickerHideTopConstraint)
		UIView.animate(withDuration: 0.75) {
			self.view.layoutIfNeeded()
		}
	}

	private func showPlaceEditor() {
		if placeEditorShowTopConstraint.isActive {
			return
		}

		view.removeConstraint(placeEditorHideTopConstraint)
		view.addConstraint(placeEditorShowTopConstraint)
		UIView.animate(withDuration: 0.75) {
			self.view.layoutIfNeeded()
		}
	}

	private func hidePlaceEditor() {
		if placeEditorHideTopConstraint.isActive {
			return
		}

		view.removeConstraint(placeEditorShowTopConstraint)
		view.addConstraint(placeEditorHideTopConstraint)
		UIView.animate(withDuration: 0.75) {
			self.view.layoutIfNeeded()
		}
	}

	private func showAlertToTakeUserToSettings() {
		let alertController = UIAlertController(title: "Location not detected", message: "Please go to settings and enable location services to use this feature.", preferredStyle: .alert)

		let settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) in
			guard let settingsUrl = URL(string: UIApplicationOpenSettingsURLString) else {
				return
			}
			if UIApplication.shared.canOpenURL(settingsUrl) {
				UIApplication.shared.open(settingsUrl, options: [:])
			}
		}
		alertController.addAction(settingsAction)

		let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
		alertController.addAction(cancelAction)

		present(alertController, animated: true)
	}

}

// MARK: IBActions
private extension CostSheetEntryViewController {

	@IBAction func navigationBarTitleButtonPressed(_ sender: UIButton) {
		switch entryType {
		case .income:
			entryType = .expense
		case .expense:
			entryType = .income
		}
		updateViewsBasedOnEntryType()
	}

	@IBAction func currencyButtonPressed(_ sender: Any) {
		amountTextView.resignFirstResponder()
		descriptionTextView.resignFirstResponder()
	}

	@IBAction func categoryViewTapped(_ sender: Any) {
		amountTextView.resignFirstResponder()
		descriptionTextView.resignFirstResponder()

		hideDatePicker()
		hidePlaceEditor()
		showCategoryPicker()
	}

	@IBAction func placeViewTapped(_ sender: Any) {
		amountTextView.resignFirstResponder()
		descriptionTextView.resignFirstResponder()

		hideCategoryPicker()
		hideDatePicker()

		if entryPlace == nil {
			openPlacePicker()
		} else {
			showPlaceEditor()
		}
	}

	@IBAction func changePlaceButtonPressed(_ sender: Any) {
		openPlacePicker()
	}

	@IBAction func deletePlaceButtonPressed(_ sender: Any) {
		entryPlace = nil
		updatePlaceViews(place: entryPlace)
		hidePlaceEditor()
	}

	@IBAction func imageButtonPressed(_ sender: Any) {
		amountTextView.resignFirstResponder()
		descriptionTextView.resignFirstResponder()
	}

	@IBAction func dateViewTapped(_ sender: Any) {
		amountTextView.resignFirstResponder()
		descriptionTextView.resignFirstResponder()

		hideCategoryPicker()
		hidePlaceEditor()
		showDatePicker()
	}

	@IBAction func saveButtonPressed(_ sender: Any) {
		guard let dataSource = dataSource,
			let deltaDelegate = deltaDelegate else {
				assertionFailure()
				return
		}

		// Getting data for entry
		let amount = Float(amountTextView.text)!
		let category = entryCategoryPicker.selectedCategory
		let dateData = NSKeyedArchiver.archivedData(withRootObject: entryDatePicker.datePicker.date)
		let descriptionText: String
		if let desctiptionTextViewText = descriptionTextView.text {
			descriptionText = desctiptionTextViewText
		} else  {
			descriptionText = ""
		}

		if var oldEntry = oldEntry {
			// Updating oldEntry
			oldEntry.type = entryType
			oldEntry.amount = amount
			oldEntry.category = category
			if let place = entryPlace {
				oldEntry.place = place
			} else {
				oldEntry.clearPlace()
			}
			oldEntry.date = dateData
			oldEntry.description_p = descriptionText
			let updateEntryComp = DeltaUtil.getComponentToUpdateEntryWithId(oldEntry.id, with: oldEntry, inCostSheetWithId: dataSource.costSheetId, document: dataSource.document)
			deltaDelegate.sendDeltaComponents([updateEntryComp])
		} else {
			// Creating new entry
			var entry = CostSheetEntry()
			entry.id = UUID().uuidString
			entry.type = entryType
			entry.amount = amount
			entry.category = category
			if let place = entryPlace {
				entry.place = place
			}
			entry.date = dateData
			entry.description_p = descriptionText
			let insertEntryComp = DeltaUtil.getComponentToInsertEntry(entry, inCostSheetWithId: dataSource.costSheetId, document: dataSource.document)
			deltaDelegate.sendDeltaComponents([insertEntryComp])
		}

		oldEntry = nil
		navigationController?.popViewController(animated: true)
	}

}

// MARK: EntryDatePickerDelegate
extension CostSheetEntryViewController: EntryDatePickerDelegate {

	func dateChanged(to date: Date) {
		updateDateViews(date: date)
	}

}

// MARK: EntryCategoryPickerDelegate
extension CostSheetEntryViewController: EntryCategoryPickerDelegate {

	func categoryChanged(to category: CostSheetEntry.Category) {
		updateCategoryViews(category: category)
	}

}

// MARK: GMSPlacePickerViewControllerDelegate
extension CostSheetEntryViewController: GMSPlacePickerViewControllerDelegate {

	func placePicker(_ viewController: GMSPlacePickerViewController, didPick place: GMSPlace) {
//		entryPlace = nil
		entryPlace = Place()
		entryPlace?.id = place.placeID
		entryPlace?.name = place.name
		entryPlace?.latitude = place.coordinate.latitude
		entryPlace?.longitude = place.coordinate.longitude
		if let address = place.formattedAddress {
			entryPlace?.address = address
		}
		if let phoneNumber = place.phoneNumber {
			entryPlace?.phoneNumber = phoneNumber
		}
		updatePlaceViews(place: entryPlace)
		viewController.dismiss(animated: true) {
			self.showPlaceEditor()
		}
	}

	func placePickerDidCancel(_ viewController: GMSPlacePickerViewController) {
		viewController.dismiss(animated: true)
	}

}

// MARK: CLLocationManagerDelegate
extension CostSheetEntryViewController: CLLocationManagerDelegate {

	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		manager.stopUpdatingLocation()

		// Getting viewPort
		let location = locations.last!
		let latitude = location.coordinate.latitude
		let longitude = location.coordinate.longitude
		let center = CLLocationCoordinate2DMake(latitude, longitude)
		let northEast = CLLocationCoordinate2DMake(center.latitude + 0.001, center.longitude + 0.001)
		let southWest = CLLocationCoordinate2DMake(center.latitude - 0.001, center.longitude - 0.001)
		let viewPort = GMSCoordinateBounds(coordinate: northEast, coordinate: southWest)

		let config = GMSPlacePickerConfig(viewport: viewPort)
		let placePicker = GMSPlacePickerViewController(config: config)
		placePicker.delegate = self

		present(placePicker, animated: true, completion: nil)
	}

	func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
		manager.stopUpdatingLocation()
		print("locationManager Error: \(error.localizedDescription)")
	}

}
