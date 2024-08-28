//
//  LocationService.swift
//  MC3
//
//  Created by Hansen Yudistira on 15/08/24.
//

import CoreLocation

//class LocationService: NSObject, CLLocationManagerDelegate {
//    static let shared = LocationService()
//    
//    private let locationManager = CLLocationManager()
//    
//    private override init() {
//        super.init()
//        locationManager.delegate = self
//        locationManager.requestAlwaysAuthorization()
//    }
//    
//    func startMonitoring(reminder: Reminder) {
//        guard let location = reminder.location, let radius = reminder.radius else { return }
//        let region = CLCircularRegion(center: location, radius: radius, identifier: reminder.id.uuidString)
//        region.notifyOnExit = true
//        locationManager.startMonitoring(for: region)
//    }
//    
//    func stopMonitoring(reminder: Reminder) {
//        guard let location = reminder.location, let radius = reminder.radius else { return }
//        let region = CLCircularRegion(center: location, radius: radius, identifier: reminder.id.uuidString)
//        locationManager.stopMonitoring(for: region)
//    }
//    
//    // CLLocationManagerDelegate methods
//    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
//        // Handle region enter
//    }
//    
//    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
//        // Handle region exit
//    }
//}
