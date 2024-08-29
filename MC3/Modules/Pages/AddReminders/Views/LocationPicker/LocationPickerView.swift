//
//  LocationPickerView.swift
//  MC3
//
//  Created by Hansen Yudistira on 19/08/24.
//

import UIKit
import MapKit
import CoreLocationUI

class LocationPickerView: UIStackView {
    let mapView = MKMapView()
//    let selectionButton = SelectionButton()
    let searchButton = SearchButton()
    let segmentedControl = LocationSegmentedControl()
    private let locationButton = CLLocationButton()
    var onSearchButtonTapped: (() -> Void)?
    var onLocationButtonTapped: (() -> Void)?
    
    var currentRadius: CLLocationDistance = 100.0
    var centerAnnotation = MKPointAnnotation()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        mapView.delegate = self
        setupView()
//        configureSelectionButton()
        addMapMoveObserver()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        axis = .vertical
        spacing = 8
        backgroundColor = .systemBackground
        layer.cornerRadius = 10
        translatesAutoresizingMaskIntoConstraints = false
        
//        addArrangedSubview(selectionButton)
//        selectionButton.anchor(top: topAnchor, leading: leadingAnchor, trailing: trailingAnchor, paddingTop: 8, paddingLeading: 8, paddingTrailing: 8, height: 50)
        
        setuplocationButton()
        
        addArrangedSubview(searchButton)
        searchButton.anchor(top: topAnchor, leading: leadingAnchor, trailing: trailingAnchor, paddingTop: 8, paddingLeading: 8, paddingTrailing: 8, height: 24)
        searchButton.addTarget(self, action: #selector(searchButtonTapped), for: .touchUpInside)

        addArrangedSubview(mapView)
        mapView.anchor(top: searchButton.bottomAnchor, leading: leadingAnchor, trailing: trailingAnchor, paddingTop: 8, width: layer.frame.width, height: 200)
        
        locationButton.anchor(bottom: mapView.bottomAnchor, trailing: mapView.trailingAnchor, paddingBottom: 8, paddingTrailing: 8)
        
        let radiusLabel = UILabel()
        radiusLabel.text = "Set Radius"
        radiusLabel.font = UIFont.systemFont(ofSize: 16)
        radiusLabel.textColor = UIColor(named: "Black")
        
        addArrangedSubview(radiusLabel)
        addArrangedSubview(segmentedControl)
        
        radiusLabel.anchor(top: mapView.bottomAnchor, leading: leadingAnchor, bottom: segmentedControl.topAnchor, trailing: trailingAnchor, paddingTop: 16, paddingLeading: 8, paddingBottom: 8)
        segmentedControl.addTarget(self, action: #selector(locationSegmentChanged(_ :)), for: .valueChanged)
        
        segmentedControl.anchor(top: radiusLabel.bottomAnchor, leading: leadingAnchor, trailing: trailingAnchor)
        addCenterAnnotation()
    }
    
    private func setuplocationButton() {
        locationButton.setSize(height: 50, width: 50)
        locationButton.cornerRadius = 25
        
        locationButton.icon = .arrowFilled
        
        mapView.addSubview(locationButton)
        
        locationButton.backgroundColor = .systemBackground
        locationButton.tintColor = .systemPurple
        locationButton.addTarget(self, action: #selector(locationButtonTapped), for: .touchUpInside)
    }
    
    private func addMapMoveObserver() {
        mapView.delegate = self
        mapView.setRegion(mapView.region, animated: true)
    }
    
    func addCenterAnnotation() {
        let centerCoordinate = mapView.centerCoordinate
        centerAnnotation.coordinate = centerCoordinate
        mapView.addAnnotation(centerAnnotation)
        addRadiusOverlay()
    }

    func updateCenterAnnotation() {
        let centerCoordinate = mapView.centerCoordinate
        centerAnnotation.coordinate = centerCoordinate
        updateRadiusOverlay()
    }
    
    private func addRadiusOverlay() {
        let circleOverlay = MKCircle(center: centerAnnotation.coordinate, radius: currentRadius)
        mapView.addOverlay(circleOverlay)
    }
    
    private func updateRadiusOverlay() {
        mapView.removeOverlays(mapView.overlays)
        let circleOverlay = MKCircle(center: centerAnnotation.coordinate, radius: currentRadius)
        mapView.addOverlay(circleOverlay)
    }
//    add this function if you want to add arriving or leaving selection button
//    private func configureSelectionButton() {
//        selectionButton.selectionHandler = { selectedOption in
//            print("Selected option: \(selectedOption)")
//        }
//    }
    
    func configure(with reminder: Reminder) {
        if let latitude = reminder.locationLatitude, let longitude = reminder.locationLongitude {
            let initialLocation = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            let region = MKCoordinateRegion(center: initialLocation, span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02))
            mapView.setRegion(region, animated: true)
            centerAnnotation.coordinate = initialLocation
        }
        
        if let radius = reminder.radius {
            switch radius {
            case 100:
                segmentedControl.selectedSegmentIndex = 0
                currentRadius = 100
            case 200:
                segmentedControl.selectedSegmentIndex = 1
                currentRadius = 200
            case 500:
                segmentedControl.selectedSegmentIndex = 2
                currentRadius = 500
            default:
                segmentedControl.selectedSegmentIndex = UISegmentedControl.noSegment
            }
            updateRadiusOverlay()
        }
    }
    
    @objc private func searchButtonTapped() {
        onSearchButtonTapped?()
    }
    
    @objc private func locationButtonTapped() {
        onLocationButtonTapped?()
    }
    
    @objc private func locationSegmentChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            currentRadius = 100
            updateRadiusOverlay()
        case 1:
            currentRadius = 200
            updateRadiusOverlay()
        case 2:
            currentRadius = 500
            updateRadiusOverlay()
        default:
            break
        }
    }
}

extension LocationPickerView: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: any MKAnnotation) -> MKAnnotationView? {
        if annotation === centerAnnotation {
            let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "marker") as? MKMarkerAnnotationView
            annotationView?.annotation = annotation
            
            if annotationView == nil {
                let annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "marker")
                annotationView.glyphImage = UIImage(systemName: "circle.fill")
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
        circleRenderer.strokeColor = .systemGreen.withAlphaComponent(0.5)
        circleRenderer.fillColor = .systemGreen.withAlphaComponent(0.3)
        circleRenderer.lineWidth = 1
        return circleRenderer
    }
    
    func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
        updateCenterAnnotation()
    }
}
