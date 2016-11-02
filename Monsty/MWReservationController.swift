//
//  MWReservationController.swift
//  Monsty!
//
//  Created by dyashe on 8/27/16.
//  Copyright © 2016 monstyware. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class MWReservationController: UITableViewController, UISearchControllerDelegate, UISearchResultsUpdating  {
    
    @IBOutlet weak var searchView: UIView!
    
    let tableViewRowHeight = CGFloat(20)
    let searchBarEntryFontSize = CGFloat(12)
    let searchResultFontSize = CGFloat(10)
    let fontName = "HelveticaNeue-Thin"

    var searchController: UISearchController!
    var mapController: MWMapController!
    
    typealias Location = (name: String, address: String)
    var arrayOfHotelNames:[Location] = [
        ("Chaminade", "1 Chaminade Ln Santa Cruz, CA 95065"),
        ("Continental Santa Cruz", "414 Ocean St, Santa Cruz, CA 95060"),
        ("Fairmont San Jose", "170 S Market St, San Jose, CA 95113"),
        ("Four Seasons Palo Alto", "2050 University Ave, East Palo Alto, CA 94303"),
        ("Hilton San Jose", "300 S Almaden Blvd, San Jose, CA 95110"),
        ("Hilton Santa Clara", "4949 Great America Pkwy, Santa Clara, CA 95054"),
        ("Hotel DeAnza", "233 W Santa Clara St, San Jose, CA 95113"),
        ("Hyatt Santa Clara", "5101 Great America Pkwy, Santa Clara, CA 95054"),
        ("Hyatt Place San Jose", "282 S Almaden Blvd, San Jose, CA 95113"),
        ("Marriott San Jose", "301 S Market St, San Jose, CA 95113")
    ]
    var hotelsMatchingCriteria:[Location] = [Location]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchController = UISearchController(searchResultsController: nil)
        searchController.delegate = self
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.setBackgroundImage = nil;
        
        
        let attributes:[String:AnyObject] = [NSFontAttributeName : UIFont(name:fontName, size: searchBarEntryFontSize)!]
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).setTitleTextAttributes(attributes, for: UIControlState())
        searchController.searchBar.setScopeBarButtonTitleTextAttributes(attributes, for:UIControlState())

        view.backgroundColor = UIColor.clear
        tableView.backgroundColor = UIColor.clear
        tableView.isOpaque = false
        tableView.tableHeaderView = searchController.searchBar;
        self.reloadAndResizeEverything()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableViewRowHeight
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let searchString = searchController.searchBar.text!.uppercased()
        var count = 0
        if (searchString.characters.count > 0) {
            count = hotelsMatchingCriteria.filter { (location:Location) -> Bool in
                return (location.name.uppercased().range(of: searchString) != nil)
                }.count
        }
        return count
    }
        
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Location", for: indexPath)
        let row = (indexPath as NSIndexPath).row
        cell.textLabel?.text = hotelsMatchingCriteria[row].name
        cell.textLabel?.font = UIFont(name: fontName, size: searchResultFontSize)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let row = (indexPath as NSIndexPath).row
        searchController.searchBar.text = hotelsMatchingCriteria[row].name
        
        let hotelAddress = hotelsMatchingCriteria[0].address
        let mwRootViewController = self.view.window!.rootViewController as? MWRootViewController
        mwRootViewController?.mapController.gotoName(hotelAddress) {
            (error) -> () in
        }
    }
    
    func reloadAndResizeEverything() {
        
        tableView.reloadData()
        
        if (self.view.window != nil) {
            let mwRootViewController =  self.view.window!.rootViewController as? MWRootViewController
            var tempFrame = mwRootViewController!.reservationContainer.frame
            tempFrame.size.height += tableView.contentSize.height
            mwRootViewController!.reservationContainer.frame = tempFrame
            
            preferredContentSize = tempFrame.size
        }
    }
    
    func updateSearchResults(for searchController: UISearchController) {
    
        hotelsMatchingCriteria = [Location]()

        let searchString = searchController.searchBar.text!.uppercased()
        if (!searchString.isEmpty) {
            for currentLocation in arrayOfHotelNames {
                let currentName = currentLocation.name.uppercased()
                if (currentName.hasPrefix(searchString)) {
                    hotelsMatchingCriteria.append(currentLocation)
                }
            }
        }
        
        self.reloadAndResizeEverything()
      }
}
