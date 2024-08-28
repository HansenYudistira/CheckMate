//
//  AddReminderViewController.swift
//  MC3
//
//  Created by Hansen Yudistira on 18/08/24.
//

import UIKit
import MapKit

protocol AddReminderViewControllerDelegate: AnyObject {
    func didAddReminder()
}

class AddReminderViewController: UIViewController {
    weak var delegate: AddReminderViewControllerDelegate?
    
    var reminder: Reminder?
    
    let titleView = TitleView()
    let timeView = TimeView()
    let timePickerView = TimePickerView()
    let locationView = LocationView()
    let locationPickerView = LocationPickerView()
    let locationManager = CLLocationManager()
    
    let contentStackView = UIStackView()
    let contentScrollView = UIScrollView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        titleView.delegate = self
        timeView.delegate = self
        locationView.delegate = self
        setupLocationManager()
        
        if let reminder = reminder {
            titleView.title = reminder.title
            
            if reminder.timeSwitch {
                timeView.timeSwitch.isOn = true
                timeSwitchToggled(isOn: true)
                
                timePickerView.configure(with: reminder)
            }
            
            if reminder.locationSwitch {
                locationView.locationSwitch.isOn = true
                locationSwitchToggled(isOn: true)
                
                locationPickerView.configure(with: reminder)
            }
            
            navigationItem.rightBarButtonItem?.title = "Save"
            navigationItem.rightBarButtonItem?.isEnabled = false
            updateNextButtonState()
        }
        
        locationPickerView.onSearchButtonTapped = { [weak self] in
            self?.showSearchViewController()
        }
        
        locationPickerView.onLocationButtonTapped = { [weak self] in
            self?.getCurrentLocation()
        }
        
        checkLocationAuthorization()
    }
    
    private func setupView() {
        view.backgroundColor = .secondarySystemBackground
        navigationItem.title = "New Reminder"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelButtonTapped))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(nextButtonTapped))
        navigationItem.rightBarButtonItem?.isEnabled = false
        
        let triggerLabel = UILabel()
        triggerLabel.text = "Trigger"
        triggerLabel.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        triggerLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(contentScrollView)
        
        contentStackView.axis = .vertical
        contentStackView.spacing = 10
        contentScrollView.addSubview(contentStackView)
        
        contentScrollView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor)
        
        contentStackView.anchor(top: contentScrollView.topAnchor, leading: contentScrollView.leadingAnchor, bottom: contentScrollView.bottomAnchor, trailing: contentScrollView.trailingAnchor, paddingTop: 16, paddingLeading: 16, paddingBottom: 16, paddingTrailing: 16)
        
        let paddingLeading = CGFloat(16)
        let paddingTrailing = CGFloat(16)
        let widthConstraint = contentStackView.widthAnchor.constraint(equalTo: contentScrollView.widthAnchor, constant: -paddingLeading - paddingTrailing)
        NSLayoutConstraint.activate([widthConstraint])
        
        contentStackView.addArrangedSubview(titleView)
        contentStackView.addArrangedSubview(triggerLabel)
        contentStackView.addArrangedSubview(timeView)
        contentStackView.addArrangedSubview(locationView)
    }
    
    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        setInitialRegion()
    }
    
    private func setInitialRegion() {
        locationManager.requestLocation()
        guard let userLocation = locationManager.location else {
            let defaultCoordinate = CLLocationCoordinate2D(latitude: -6.2088, longitude: 106.8456)
            let region = MKCoordinateRegion(center: defaultCoordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            locationPickerView.mapView.setRegion(region, animated: true)
            return
        }
        
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let region = MKCoordinateRegion(center: userLocation.coordinate, span: span)
        
        locationPickerView.mapView.setRegion(region, animated: true)
    }
    
    @objc private func cancelButtonTapped() {
        if presentingViewController != nil {
            dismiss(animated: true, completion: nil)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
    
    @objc private func getCurrentLocation() {
        locationManager.startUpdatingLocation()
    }
    
    private func checkLocationAuthorization() {
        switch locationManager.authorizationStatus {
        case .notDetermined:
            locationManager.requestAlwaysAuthorization()
            locationManager.requestWhenInUseAuthorization()
        case .restricted, .denied:
            handleLocationPermissionDenied()
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.startUpdatingLocation()
        @unknown default:
            break
        }
    }
    
    private func handleLocationPermissionDenied() {
        let alert = UIAlertController(
            title: "Location Permission Denied",
            message: "Please enable location permissions in settings to use this feature.",
            preferredStyle: .alert
        )
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    @objc private func nextButtonTapped() {
        var time: Date? = nil
        var selectedDays: [Int] = []
        var selectedNotificationType: String?
        var selectedLatitude: Double?
        var selectedLongitude: Double?
        var selectedRadius: Double?
        var placeMark = ""
        
        let title = titleView.titleTextView.text ?? "No Title"
        
        if timeView.timeSwitch.isOn {
            time = timePickerView.timePicker.date
            selectedDays = getSelectedDays()
        }
        
        if locationView.locationSwitch.isOn {
            selectedNotificationType = "Leaving"
            selectedLatitude = locationPickerView.centerAnnotation.coordinate.latitude
            selectedLongitude = locationPickerView.centerAnnotation.coordinate.longitude
            selectedRadius = locationPickerView.currentRadius
            let coordinate = CLLocationCoordinate2D(latitude: selectedLatitude ?? 0.0, longitude: selectedLongitude ?? 0.0)
            getPlacemarkName(from: coordinate) { [weak self] placemarkName in
                guard let self = self else { return }
                
                placeMark = placemarkName ?? ""
                
                if let reminder = reminder {
                    reminder.title = title
                    reminder.timeSwitch = timeView.timeSwitch.isOn
                    reminder.time = time
                    reminder.days = selectedDays
                    reminder.notificationType = selectedNotificationType ?? "No"
                    reminder.locationLatitude = selectedLatitude ?? 0.0
                    reminder.locationLongitude = selectedLongitude ?? 0.0
                    reminder.placeMark = placeMark
                    reminder.radius = selectedRadius ?? 0.0
                    reminder.locationSwitch = locationView.locationSwitch.isOn
                    
                } else {
                    self.reminder = Reminder(
                        title: title,
                        timeSwitch: timeView.timeSwitch.isOn,
                        time: time,
                        days: selectedDays,
                        notificationType: selectedNotificationType ?? "No",
                        locationLatitude: selectedLatitude ?? 0.0,
                        locationLongitude: selectedLongitude ?? 0.0,
                        placeMark: placeMark,
                        radius: selectedRadius ?? 0.0,
                        locationSwitch: locationView.locationSwitch.isOn,
                        checklist: [],
                        colorTag: "#F1A804",
                        symbolTag: "balloon.fill"
                    )
                }
            }
        } else {
            if let reminder = reminder {
                reminder.title = title
                reminder.timeSwitch = timeView.timeSwitch.isOn
                reminder.time = time
                reminder.days = selectedDays
                reminder.notificationType = selectedNotificationType ?? "No"
                reminder.locationLatitude = selectedLatitude ?? 0.0
                reminder.locationLongitude = selectedLongitude ?? 0.0
                reminder.placeMark = placeMark
                reminder.radius = selectedRadius ?? 0.0
                reminder.locationSwitch = locationView.locationSwitch.isOn
            } else {
                self.reminder = Reminder(
                    title: title,
                    timeSwitch: timeView.timeSwitch.isOn,
                    time: time,
                    days: selectedDays,
                    notificationType: selectedNotificationType ?? "No",
                    locationLatitude: selectedLatitude ?? 0.0,
                    locationLongitude: selectedLongitude ?? 0.0,
                    placeMark: placeMark,
                    radius: selectedRadius ?? 0.0,
                    locationSwitch: locationView.locationSwitch.isOn,
                    checklist: [],
                    colorTag: "systemOrange",
                    symbolTag: "balloon.fill"
                )
            }
        }
        
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.center = self.view.center
        self.view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            activityIndicator.stopAnimating()
            activityIndicator.removeFromSuperview()
            let checklistVC = ChecklistViewController()
            checklistVC.delegate = self
            checklistVC.reminder = self.reminder
            checklistVC.modalPresentationStyle = .formSheet
            self.navigationController?.pushViewController(checklistVC, animated: true)
        }
    }
    
    private func getSelectedDays() -> [Int] {
        var selectedDays: [Int] = []
        
        for case let button as UIButton in timePickerView.daysStackView.arrangedSubviews {
            if button.isSelected {
                selectedDays.append(button.tag)
            }
        }
        
        return selectedDays
    }
    
    func getPlacemarkName(from coordinate: CLLocationCoordinate2D, completion: @escaping (String?) -> Void) {
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        let geocoder = CLGeocoder()
        
        geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
            if let error = error {
                print("Failed to reverse geocode location: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            if let placemark = placemarks?.first {
                let name = placemark.name ?? "Unnamed place"
                completion(name)
            } else {
                completion(nil)
            }
        }
    }
    
    private func addTimePicker() {
        contentStackView.insertArrangedSubview(timePickerView, at: 3)
    }
    
    private func removeTimePicker() {
        timePickerView.removeFromSuperview()
    }
    
    private func addLocationPicker() {
        contentStackView.addArrangedSubview(locationPickerView)
    }
    
    private func removeLocationPicker() {
        locationPickerView.removeFromSuperview()
    }
    
    func showSearchViewController() {
        let searchVC = SearchViewController()
        searchVC.delegate = self
        let navController = UINavigationController(rootViewController: searchVC)
        self.present(navController, animated: true, completion: nil)
    }
    
    private func updateNextButtonState() {
        let hasText = titleView.titleTextView.hasText
        let isTimeOn = timeView.timeSwitch.isOn
        let isLocationOn = locationView.locationSwitch.isOn
        
        navigationItem.rightBarButtonItem?.isEnabled = hasText && (isTimeOn || isLocationOn)
    }
}

extension AddReminderViewController: TitleViewDelegate {
    func titleViewDidChange(_ titleView: TitleView, text: String) {
        updateNextButtonState()
    }
}

extension AddReminderViewController: TimeViewDelegate {
    func timeSwitchToggled(isOn: Bool) {
        titleView.titleTextView.resignFirstResponder()
        if isOn {
            addTimePicker()
        } else {
            removeTimePicker()
        }
        updateNextButtonState()
    }
}

extension AddReminderViewController: LocationViewDelegate {
    func locationSwitchToggled(isOn: Bool) {
        titleView.titleTextView.resignFirstResponder()
        if isOn {
            addLocationPicker()
        } else {
            removeLocationPicker()
        }
        updateNextButtonState()
    }
}

extension AddReminderViewController: SearchViewControllerDelegate {
    func didSelectLocation(_ location: MKPlacemark) {
        let coordinate = location.coordinate
        let region = MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        locationPickerView.mapView.setRegion(region, animated: true)
    }
}

extension AddReminderViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            return
        }
        
        locationPickerView.mapView.setRegion(MKCoordinateRegion(
            center: location.coordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)), animated: true
        )
        
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to get user location: \(error.localizedDescription)")
        
        let alert = UIAlertController(title: "Error", message: "Unable to retrieve location. Please check your location settings.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true, completion: nil)
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        let title = "You Entered the region"
        let message = "You are trapped fool !"
        print("\(title) - \(message)")
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        let title = "You Left the Region"
        let message = "Bye Fool !"
        print("\(title) - \(message)")
    }
}

extension AddReminderViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: any MKAnnotation) -> MKAnnotationView? {
        if annotation === locationPickerView.centerAnnotation {
            let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "marker") as? MKMarkerAnnotationView
            annotationView?.annotation = annotation
            
            if annotationView == nil {
                let annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "marker")
                annotationView.glyphImage = UIImage(systemName: "mappin.and.ellipse")
                annotationView.markerTintColor = .systemBlue
                return annotationView
            }
            
            return annotationView
        }
        return nil
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: any MKOverlay) -> MKOverlayRenderer {
        guard let circleOverlay = overlay as? MKCircle else { return MKOverlayRenderer() }
        let circleRenderer = MKCircleRenderer(circle: circleOverlay)
        circleRenderer.strokeColor = .systemRed
        circleRenderer.fillColor = .systemRed
        circleRenderer.alpha = 0.5
        return circleRenderer
    }
}

extension AddReminderViewController: ChecklistViewControllerDelegate {
    func refreshData() {
        delegate?.didAddReminder()
    }
}
