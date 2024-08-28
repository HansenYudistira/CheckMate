//
//  SearchViewController.swift
//  MC3
//
//  Created by Hansen Yudistira on 20/08/24.
//

import UIKit
import MapKit

protocol SearchViewControllerDelegate: AnyObject {
    func didSelectLocation(_ location: MKPlacemark)
}

class SearchViewController: UITableViewController {
    weak var delegate: SearchViewControllerDelegate?
    let searchController = UISearchController()
    var matchingLocations: [MKMapItem] = []
    var userLocation: CLLocation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Search"
        addSearchController()
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        getCurrentLocation()
    }
    
    @objc private func dismissSearch() {
        dismiss(animated: true, completion: nil)
    }
    
    func addSearchController() {
        searchController.searchBar.sizeToFit()
        searchController.searchBar.backgroundImage = UIImage()
        searchController.searchBar.tintColor = .systemPurple
        searchController.searchBar.searchTextField.leftView?.tintColor = .systemPurple
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(dismissSearch))
    }
    
    func getCurrentLocation() {
        let locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
}

extension SearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        performSearch()
    }
    
    func performSearch() {
        guard let searchBarText = searchController.searchBar.text, !searchBarText.isEmpty else { return }
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchBarText
        
        let search = MKLocalSearch(request: request)
        
        search.start { response, error in
            if let error = error {
                print("Search Failed", error.localizedDescription)
                return
            }
            
            guard let response = response else {
                print("No response from search")
                return
            }
            
            self.matchingLocations = response.mapItems
            
            if let userLocation = self.userLocation {
                self.matchingLocations.sort { (item1, item2) -> Bool in
                    let distance1 = item1.placemark.location?.distance(from: userLocation) ?? CLLocationDistanceMax
                    let distance2 = item2.placemark.location?.distance(from: userLocation) ?? CLLocationDistanceMax
                    return distance1 < distance2
                }
            }
            
            self.matchingLocations = Array(self.matchingLocations.prefix(10)) //limit to 10 result
            
            self.tableView.reloadData()
        }
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            matchingLocations = []
            self.tableView.reloadData()
        }
    }
}

extension SearchViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            return
        }
        
        userLocation = location
        manager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to get user location: \(error.localizedDescription)")
    }
}

extension SearchViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return matchingLocations.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let location = matchingLocations[indexPath.row].placemark
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        var configuration = cell.defaultContentConfiguration()
        configuration.imageToTextPadding = 20
        configuration.secondaryText = location.country
        
        if let placeName = location.name {
            configuration.attributedText = NSAttributedString(string: placeName, attributes: [.font: UIFont.systemFont(ofSize: 20, weight: .bold)])
        } else {
            configuration.text = "Unknown place"
        }
        
        configuration.image = UIImage(systemName: "location.fill.viewFinder")
        configuration.imageProperties.tintColor = .systemPurple
        
        cell.contentConfiguration = configuration
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedLocation = matchingLocations[indexPath.row].placemark
        delegate?.didSelectLocation(selectedLocation)
        dismiss(animated: true, completion: nil)
    }
}

