//
//  CostSheetEntryViewController.swift
//  Cost Track
//
//  Created by Karthik M S on 18/07/18.
//  Copyright © 2018 Karthik M S. All rights reserved.
//

import UIKit
import GooglePlacePicker
import AVKit
import CoreServices

class CostSheetEntryViewController: UIViewController {

	private enum SettingsReason {
		case location
		case camera
	}

	// MARK: IBOutlets
	// Views
	@IBOutlet weak var navigationBarTitleButton: UIButton!
	@IBOutlet weak var amountBarView: UIView!
	@IBOutlet weak var amountTextView: UITextView!
	@IBOutlet weak var categoryLabel: UILabel!
	@IBOutlet weak var imageButton: UIButton!
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

	@IBOutlet weak var imageEditorHeightConstraint: NSLayoutConstraint!
	@IBOutlet weak var imageEditorHideTopConstraint: NSLayoutConstraint!
	@IBOutlet weak var imageEditorShowTopConstraint: NSLayoutConstraint!
	@IBOutlet weak var selectFromGalleryButtonHeightConstraint: NSLayoutConstraint!
	@IBOutlet weak var takePhotoButtonHeightConstraint: NSLayoutConstraint!

	@IBOutlet weak var configurationBar: UIView!

	// MARK: Properties
	private weak var dataSource: CostSheetDataSource!
	private weak var deltaDelegate: DeltaDelegate!
	func setup(dataSource: CostSheetDataSource, deltaDelegate: DeltaDelegate) {
		self.dataSource = dataSource
		self.deltaDelegate = deltaDelegate
	}
	var entryType = EntryType.income
	var oldEntry: CostSheetEntry?
	private let locationManager = CLLocationManager()
	private var entryPlace: Place?
	var isDirectAmountTransfer = false
	private var transferCostSheet: CostSheet?
	private let imagePicker = UIImagePickerController()
	private var image: UIImage?

	// MARK: UIViewController functions
    override func viewDidLoad() {
        super.viewDidLoad()

		entryDatePicker.delegate = self
		entryCategoryPicker.dataSource = self
		entryCategoryPicker.delegate = self

		locationManager.distanceFilter = 50
		locationManager.desiredAccuracy = kCLLocationAccuracyBest
		locationManager.delegate = self

		if oldEntry != nil {
			updateViewsForOldEntry()
		} else {
			updateViewsToDefaultValues()
		}

		if isDirectAmountTransfer {
			performSegue(withIdentifier: TransferAmountSegue, sender: nil)
		}

		initImagePicker()
    }

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)

		// Calculating height constraints for views in the bottom
		let viewHeights = amountBarView.frame.size.height + configurationBar.frame.size.height + descriptionTextView.frame.size.height
		categoryPickerHeightConstraint.constant = view.frame.size.height - navigationController!.navigationBar.frame.size.height - (view.safeAreaInsets.top + view.safeAreaInsets.bottom) - viewHeights
		datePickerHeightConstraint.constant = categoryPickerHeightConstraint.constant
		placeEditorHeightConstraint.constant = categoryPickerHeightConstraint.constant
		imageEditorHeightConstraint.constant = categoryPickerHeightConstraint.constant
		updateImageEditorView(for: image)
	}

	// MARK: Navigation
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == TransferAmountSegue {
			guard let amount = Float(amountTextView.text),
				let transferAmountViewController = segue.destination as? TransferAmountViewController else {
					assertionFailure()
					return
			}
			transferAmountViewController.setup(
				delegate: self,
				document: dataSource.document,
				costSheetId: dataSource.costSheetId,
				entryType: entryType,
				amount: amount
			)
		}
	}

	private func segueToTransferAmountViewController() {
		guard dataSource.document.costSheets.count > 1 else {
			showAlertForInsufficientCostSheets()
			return
		}
		performSegue(withIdentifier: TransferAmountSegue, sender: nil)
	}

	// MARK: Initialization functions
	private func initImagePicker() {
		imagePicker.mediaTypes = [kUTTypeImage as String]
		imagePicker.delegate = self
	}

	// MARK: Location functions
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
				showAlertToTakeUserToSettings(reason: .location)
			default:
				return
			}
		} else {
			showAlertToTakeUserToSettings(reason: .location)
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
		if oldEntry.hasImage {
			image = UIImage(data: oldEntry.image)
			updateImageEditorView(for: image)
		}
		updateDateViews(date: oldEntryDate)
		if oldEntry.hasPlace {
			entryPlace = oldEntry.place
			updatePlaceViews(place: oldEntry.place)
		} else {
			updatePlaceViews(place: nil)
		}
		descriptionTextView.text = oldEntry.description_p
		descriptionTextView.textColor = .black
	}

	private func updateViewsToDefaultValues() {
		updateViewsBasedOnEntryType()
		amountTextView.text = "0.00"
		updateCategoryViews(category: nil)
		updateDateViews(date: Date())
		descriptionTextView.text = "Enter description..."
		descriptionTextView.textColor = .lightGray
	}

	private func updateViewsBasedOnEntryType() {
		switch entryType {
		case .expense:
			navigationBarTitleButton.setTitle("Expense", for: .normal)
			navigationBarTitleButton.setTitleColor(DarkExpenseColor, for: .normal)
			amountBarView.backgroundColor = LightExpenseColor
		case .income:
			navigationBarTitleButton.setTitle("Income", for: .normal)
			navigationBarTitleButton.setTitleColor(DarkIncomeColor, for: .normal)
			amountBarView.backgroundColor = LightIncomeColor
		}
	}

	private func updateCategoryViews(category: Category?) {
		if let category = category {
			entryCategoryPicker.selectCategory(category)
		} else {
			entryCategoryPicker.categoryPickerView.selectRow(0, inComponent: 0, animated: false)
		}
		categoryLabel.text = entryCategoryPicker.selectedCategory.name
	}

	private func updateImageEditorView(for image: UIImage?) {
		if let image = image {
			imageButton.setTitle("", for: .normal)
			imageButton.setBackgroundImage(image, for: .normal)
			takePhotoButtonHeightConstraint.constant = categoryPickerHeightConstraint.constant / 2
			selectFromGalleryButtonHeightConstraint.constant = categoryPickerHeightConstraint.constant / 2
		} else {
			imageButton.setTitle("Img", for: .normal)
			imageButton.setBackgroundImage(nil, for: .normal)
			takePhotoButtonHeightConstraint.constant = categoryPickerHeightConstraint.constant
			selectFromGalleryButtonHeightConstraint.constant = categoryPickerHeightConstraint.constant
		}
		UIView.animate(withDuration: 0.1) {
			self.view.layoutIfNeeded()
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

	private func showImageEditor() {
		if imageEditorShowTopConstraint.isActive {
			return
		}

		view.removeConstraint(imageEditorHideTopConstraint)
		view.addConstraint(imageEditorShowTopConstraint)
		UIView.animate(withDuration: 0.75) {
			self.view.layoutIfNeeded()
		}
	}

	private func hideImageEditor() {
		if imageEditorHideTopConstraint.isActive {
			return
		}

		view.removeConstraint(imageEditorShowTopConstraint)
		view.addConstraint(imageEditorHideTopConstraint)
		UIView.animate(withDuration: 0.75) {
			self.view.layoutIfNeeded()
		}
	}

	private func showAlertToTakeUserToSettings(reason: SettingsReason) {
		let title: String!, message: String!
		switch reason {
		case .location:
			title = "Location not detected"
			message = "Please go to settings and enable location services to use this feature."
		case .camera:
			title = "Camera not enabled"
			message = "Please go to settings and enable camera to use this feature."
		}
		let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)

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

	private func showAlertForInsufficientCostSheets() {
		let alertController = UIAlertController(title: nil, message: "No other cost sheets to move entry to. Create more cost sheets.", preferredStyle: .alert)
		let okAction = UIAlertAction(title: "Ok", style: .default) { (_) in
			alertController.dismiss(animated: true)
		}
		alertController.addAction(okAction)
		present(alertController, animated: true)
	}

	private func showPhotoAlbum() {
		guard let availableMediaTypes = UIImagePickerController.availableMediaTypes(for: .camera),
			availableMediaTypes.contains(kUTTypeImage as String) else {
				showAlertSaying("Image not supported")
				return
		}
		imagePicker.sourceType = .photoLibrary
		present(imagePicker, animated: true)
	}

	private func showCamera() {
		guard let availableMediaTypes = UIImagePickerController.availableMediaTypes(for: .camera),
			availableMediaTypes.contains(kUTTypeImage as String) else {
				showAlertSaying("Image not supported")
				return
		}
		imagePicker.sourceType = .camera
		present(imagePicker, animated: true)
	}

}

// MARK: IBActions
extension CostSheetEntryViewController {

	@IBAction func navigationBarTitleButtonPressed(_ sender: UIButton) {
		var oldSelectedCategory: Category?
		// Once an entry has transferCostSheetId, it's category cannot be changed
		if (transferCostSheet == nil) && (oldEntry != nil && oldEntry!.category.name == "Transfer") {
			oldSelectedCategory = entryCategoryPicker.selectedCategory
		}

		switch entryType {
		case .income:
			entryType = .expense
		case .expense:
			entryType = .income
		}
		updateViewsBasedOnEntryType()

		if (transferCostSheet == nil) && (oldEntry != nil && oldEntry!.category.name == "Transfer") {
			// If the oldSelectedCategory does not belong to both entry types, the first category is selected. If it does, the correct row is selected.
			entryCategoryPicker.categoryPickerView.reloadComponent(0)
			guard let oldSelectedCategory = oldSelectedCategory else {
				assertionFailure()
				return
			}
			if categoriesFilteredByEntryType.contains(oldSelectedCategory) {
				updateCategoryViews(category: oldSelectedCategory)
			} else {
				updateCategoryViews(category: nil)
			}
		}

	}

	@IBAction func currencyButtonPressed(_ sender: Any) {
		amountTextView.resignFirstResponder()
		descriptionTextView.resignFirstResponder()
	}

	@IBAction func categoryViewTapped(_ sender: Any) {
		amountTextView.resignFirstResponder()
		descriptionTextView.resignFirstResponder()

		guard transferCostSheet == nil else {
			performSegue(withIdentifier: TransferAmountSegue, sender: nil)
			return
		}
		if let oldEntry = oldEntry,
			oldEntry.category.name == "Transfer" {
			segueToTransferAmountViewController()
			return
		}

		hideDatePicker()
		hidePlaceEditor()
		hideImageEditor()
		showCategoryPicker()
	}

	@IBAction func placeViewTapped(_ sender: Any) {
		amountTextView.resignFirstResponder()
		descriptionTextView.resignFirstResponder()

		hideCategoryPicker()
		hideDatePicker()
		hideImageEditor()

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

		hideDatePicker()
		hidePlaceEditor()
		hideCategoryPicker()
		showImageEditor()
	}

	@IBAction func selectFromGalleryButtonPressed(_ sender: Any) {
		showPhotoAlbum()
	}

	@IBAction func takePhotoButtonPressed(_ sender: Any) {
		guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
			return
		}

		switch AVCaptureDevice.authorizationStatus(for: .video) {
		case .authorized:
			showCamera()
		case .notDetermined:
			AVCaptureDevice.requestAccess(for: .video) { granted in
				if granted {
					self.showCamera()
				}
			}
		case .denied:
			showAlertToTakeUserToSettings(reason: .camera)
		case .restricted:
			return
		}
	}

	@IBAction func deletePhotoButtonPressed(_ sender: Any) {
		image = nil
		updateImageEditorView(for: nil)
	}

	@IBAction func viewPhotoButtonPressed(_ sender: Any) {
	}

	@IBAction func dateViewTapped(_ sender: Any) {
		amountTextView.resignFirstResponder()
		descriptionTextView.resignFirstResponder()

		hideCategoryPicker()
		hidePlaceEditor()
		hideImageEditor()
		showDatePicker()
	}

	@IBAction func saveButtonPressed(_ sender: Any) {
		// Getting data for entry
		let amount = Float(amountTextView.text)!
		let category: Category
		if transferCostSheet == nil {
			category = entryCategoryPicker.selectedCategory
		} else {
			category = TransferCategory
		}
		var imageData: Data?
		if let image = image {
			imageData = UIImagePNGRepresentation(image)
		}
		let dateData = NSKeyedArchiver.archivedData(withRootObject: entryDatePicker.datePicker.date)
		let descriptionText: String
		if let desctiptionTextViewText = descriptionTextView.text,
			descriptionTextView.textColor == .black {
			descriptionText = desctiptionTextViewText
		} else  {
			descriptionText = ""
		}

		var deltaComps = [DocumentContentOperation.Component]()

		if var oldEntry = oldEntry {
			// Updating oldEntry
			oldEntry.type = entryType
			oldEntry.amount = amount
			if let imageData = imageData {
				oldEntry.image = imageData
			}
			if let place = entryPlace {
				oldEntry.place = place
			} else {
				oldEntry.clearPlace()
			}
			oldEntry.date = dateData
			oldEntry.description_p = descriptionText

			if let transferCostSheet = transferCostSheet {
				var newTransferEntry = CostSheetEntry()
				newTransferEntry.type = entryType == .income ? .expense : .income
				newTransferEntry.amount = amount
				newTransferEntry.category = TransferCategory
				if let imageData = imageData {
					newTransferEntry.image = imageData
				}
				if let place = entryPlace {
					newTransferEntry.place = place
				}
				newTransferEntry.date = dateData
				newTransferEntry.description_p = descriptionText
				newTransferEntry.transferCostSheetID = dataSource.costSheetId
				newTransferEntry.transferEntryID = oldEntry.id

				if oldEntry.category.name == "Transfer" {
					if oldEntry.transferCostSheetID == transferCostSheet.id {
						// Old entry has same transferCostSheetId
						newTransferEntry.id = oldEntry.transferEntryID
						let updateTransferEntryComp = DeltaUtil.getComponentToUpdateEntryWithId(oldEntry.transferEntryID, with: newTransferEntry, inCostSheetWithId: oldEntry.transferCostSheetID, document: dataSource.document)
						deltaComps.append(updateTransferEntryComp)
					} else {
						// Old entry has different transferCostSheetId
						if let deleteOldTransferEntryComp = DeltaUtil.getComponentToDeleteEntryWithId(oldEntry.transferEntryID, inCostSheetWithId: oldEntry.transferCostSheetID, document: dataSource.document) {
							deltaComps.append(deleteOldTransferEntryComp)
							newTransferEntry.id = oldEntry.transferEntryID
						} else {
							newTransferEntry.id = UUID().uuidString
						}
						let insertNewTransferEntryComp = DeltaUtil.getComponentToInsertEntry(newTransferEntry, inCostSheetWithId: transferCostSheet.id, document: dataSource.document)
						deltaComps.append(insertNewTransferEntryComp)
					}
				} else {
					// Old entry does not have transferCostSheetId
					newTransferEntry.id = UUID().uuidString

					let insertNewTransferEntryComp = DeltaUtil.getComponentToInsertEntry(newTransferEntry, inCostSheetWithId: transferCostSheet.id, document: dataSource.document)
					deltaComps.append(insertNewTransferEntryComp)
				}

				oldEntry.category = TransferCategory
				oldEntry.transferCostSheetID = transferCostSheet.id
				oldEntry.transferEntryID = newTransferEntry.id
			} else {
				// Old entry had a transferCostSheetId and entry details were changed without going to TransferAmountViewController
				oldEntry.category = category
				if oldEntry.category.name == "Transfer" {
					var newTransferEntry = dataSource.document.costSheetWithId(oldEntry.transferCostSheetID)!.entryWithId(oldEntry.transferEntryID)
					newTransferEntry.type = entryType == .income ? .expense : .income
					newTransferEntry.amount = amount
					newTransferEntry.category = TransferCategory
					if let imageData = imageData {
						newTransferEntry.image = imageData
					}
					if let place = entryPlace {
						newTransferEntry.place = place
					}
					newTransferEntry.date = dateData
					newTransferEntry.description_p = descriptionText

					let updateTransferEntryComp = DeltaUtil.getComponentToUpdateEntryWithId(oldEntry.transferEntryID, with: newTransferEntry, inCostSheetWithId: oldEntry.transferCostSheetID, document: dataSource.document)
					deltaComps.append(updateTransferEntryComp)
				}
			}

			let updateEntryComp = DeltaUtil.getComponentToUpdateEntryWithId(oldEntry.id, with: oldEntry, inCostSheetWithId: dataSource.costSheetId, document: dataSource.document)
			deltaComps.append(updateEntryComp)
		} else {
			// Creating new entry
			var newEntry = CostSheetEntry()
			newEntry.id = UUID().uuidString
			newEntry.type = entryType
			newEntry.amount = amount
			if let imageData = imageData {
				newEntry.image = imageData
			}
			if let place = entryPlace {
				newEntry.place = place
			}
			newEntry.date = dateData
			newEntry.description_p = descriptionText

			if let transferCostSheet = transferCostSheet {
				var newTransferEntry = CostSheetEntry()
				newTransferEntry.id = UUID().uuidString
				newTransferEntry.type = entryType == .income ? .expense : .income
				newTransferEntry.amount = amount
				newTransferEntry.category = TransferCategory
				if let imageData = imageData {
					newTransferEntry.image = imageData
				}
				if let place = entryPlace {
					newTransferEntry.place = place
				}
				newTransferEntry.date = dateData
				newTransferEntry.description_p = descriptionText
				newTransferEntry.transferCostSheetID = dataSource.costSheetId
				newTransferEntry.transferEntryID = newEntry.id

				newEntry.category = TransferCategory
				newEntry.transferCostSheetID = transferCostSheet.id
				newEntry.transferEntryID = newTransferEntry.id

				let insertTransferEntryComp = DeltaUtil.getComponentToInsertEntry(newTransferEntry, inCostSheetWithId: transferCostSheet.id, document: dataSource.document)
				deltaComps.append(insertTransferEntryComp)
			} else {
				newEntry.category = category
			}

			let insertEntryComp = DeltaUtil.getComponentToInsertEntry(newEntry, inCostSheetWithId: dataSource.costSheetId, document: dataSource.document)
			deltaComps.append(insertEntryComp)
		}

		deltaDelegate.sendDeltaComponents(deltaComps)

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

// MARK: EntryCategoryPickerDataSource
extension CostSheetEntryViewController: EntryCategoryPickerDataSource {

	var categoriesFilteredByEntryType: [Category] {
		let categories = dataSource.document.categories
		return categories.filter { $0.entryTypes.contains(entryType) }
	}

}

// MARK: EntryCategoryPickerDelegate
extension CostSheetEntryViewController: EntryCategoryPickerDelegate {

	func categoryChanged(to category: Category) {
		if category.name == "Transfer" {
			segueToTransferAmountViewController()
			return
		}

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

// MARK: UITextViewDelegate
extension CostSheetEntryViewController: UITextViewDelegate {

	func textViewDidBeginEditing(_ textView: UITextView) {
		if textView.textColor == .lightGray {
			textView.text = nil
			textView.textColor = .black
		}
	}

	func textViewDidEndEditing(_ textView: UITextView) {
		if textView.text.isEmpty {
			textView.text = "Enter description..."
			textView.textColor = .lightGray
		}
	}

}

// MARK: TransferAmountViewControllerDelegate
extension CostSheetEntryViewController: TransferAmountViewControllerDelegate {

	func transferSaved(transferAmountInfo: TransferAmountInfo) {
		amountTextView.text = String(transferAmountInfo.amount)

		entryType = transferAmountInfo.entryTye
		updateViewsBasedOnEntryType()

		transferCostSheet = transferAmountInfo.transferCostSheet

		categoryLabel.text = "Transfer"
		hideCategoryPicker()
	}

	func transferCancelled() {
		if transferCostSheet == nil {
			entryCategoryPicker.selectPreviousCategory()
		}
	}

}

extension CostSheetEntryViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
		image = info["UIImagePickerControllerOriginalImage"] as? UIImage
		image = rotateImageToCorrectOrientation(image!)
		updateImageEditorView(for: image)

		picker.dismiss(animated: true)
	}

	private func rotateImageToCorrectOrientation(_ image: UIImage) -> UIImage {
		if (image.imageOrientation == .up ) {
			return image
		}

		UIGraphicsBeginImageContext(image.size)

		image.draw(in: CGRect(origin: CGPoint.zero, size: image.size))
		guard let copy = UIGraphicsGetImageFromCurrentImageContext() else {
			return image
		}

		UIGraphicsEndImageContext()

		return copy
	}

}
