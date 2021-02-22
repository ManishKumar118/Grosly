//
//  LocationSearchTableViewController.swift
//  GoGrocer
//
//  Created by Pooja on 23/07/20.
//  Copyright © 2020 Komal Gupta. All rights reserved.
//

import UIKit
import MapKit

protocol HandleMapSearch {
    func dropPinZoomIn(placemark:MKPlacemark)
}

class LocationSearchTableViewController: UITableViewController {

  var matchingItems:[MKMapItem] = []
        var mapView: MKMapView? = nil
        var selectSearchView = false
        var handleMapSearchDelegate:HandleMapSearch? = nil
        //Formats Address to Display
        func parseAddress(selectedItem:MKPlacemark) -> String {
            // put a space between "4" and "Melrose Place"
            let firstSpace = (selectedItem.subThoroughfare != nil && selectedItem.thoroughfare != nil) ? " " : ""
            // put a comma between street and city/state
            let comma = (selectedItem.subThoroughfare != nil || selectedItem.thoroughfare != nil) && (selectedItem.subAdministrativeArea != nil || selectedItem.administrativeArea != nil) ? ", " : ""
            // put a space between "Washington" and "DC"
            let secondSpace = (selectedItem.subAdministrativeArea != nil && selectedItem.administrativeArea != nil) ? " " : ""
            let addressLine = String(
                format:"%@%@%@%@%@%@%@",
                // street number
                selectedItem.subThoroughfare ?? "",
                firstSpace,
                // street name
                selectedItem.thoroughfare ?? "",
                comma,
                // city
                selectedItem.locality ?? "",
                secondSpace,
                // state
                selectedItem.administrativeArea ?? ""
            )
            return addressLine
        }
    }
    //creates a custom MKLocalSearchRequest and gets MKLocalSearchResponse
    extension LocationSearchTableViewController : UISearchResultsUpdating {
        func updateSearchResults(for searchController: UISearchController) {
            guard let mapView = mapView,
                let searchBarText = searchController.searchBar.text else { return }
            let request = MKLocalSearch.Request()
            request.naturalLanguageQuery = searchBarText
            request.region = mapView.region
            let search = MKLocalSearch(request: request)
            search.start { response, _ in
                guard let response = response else {
                    return
                }
                self.matchingItems = response.mapItems
                self.tableView.reloadData()
            }
        }
    }

    extension LocationSearchTableViewController {
        //returns number of rows for the LocationSearchTable
        override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return matchingItems.count
        }
        
        //itterate the data inside the tableView
        override func tableView(_ tableView: UITableView,
                                cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
            let selectedItem = matchingItems[indexPath.row].placemark
            cell.textLabel?.text = selectedItem.name
            cell.detailTextLabel?.text = parseAddress(selectedItem: selectedItem)
            return cell
        }
    }

    extension LocationSearchTableViewController {
        //Action for selectedRow
        override func tableView(_ tableView: UITableView,didSelectRowAt indexPath: IndexPath) {
            let selectedItem = matchingItems[indexPath.row].placemark
            handleMapSearchDelegate?.dropPinZoomIn(placemark: selectedItem)
            if handleMapSearchDelegate != nil && selectedItem != nil {
                let dataToBeSent = selectedItem
                self.handleMapSearchDelegate?.dropPinZoomIn(placemark: dataToBeSent)
            }
            dismiss(animated: true, completion: nil)
            
            
        }
       
    }
