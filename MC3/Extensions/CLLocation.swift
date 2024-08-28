//
//  CLLocation.swift
//  MC3
//
//  Created by Hansen Yudistira on 14/08/24.
//

import CoreLocation

extension CLLocation {
    func fetchLocationInformation(completion: @escaping (_ placeName: String?, _ city: String?, _ country: String?, _ error: Error?) -> Void) {
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(self) { placemarks, error in
            guard let placemark = placemarks?.first, error == nil else {
                completion(nil, nil, nil, error)
                return
            }

            let placeName = placemark.name
            let city = placemark.locality
            let country = placemark.country
            completion(placeName, city, country, nil)
        }
    }
}
