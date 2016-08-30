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

class MWReservationController: UIViewController, UITableViewDataSource,  UITableViewDelegate, UISearchResultsUpdating, UISearchControllerDelegate  {
    
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    
    var searchController: UISearchController!
    var mapController: MWMapController!
    
    var arrayOfHotelNames:[(name: String, address: String)] = [
        ("Chaminade", "1 Chaminade Ln Santa Cruz, CA 95065"),
        ("Continental Santa Cruz", "414 Ocean St, Santa Cruz, CA 95060"),
        ("Fairmont San Jose", "170 S Market St, San Jose, CA 95113"),
        ("Four Seasons Palo Alto", "2050 University Ave, East Palo Alto, CA 94303"),
        ("Hilton San Jose", "300 S Almaden Blvd, San Jose, CA 95110"),
        ("Hilton Santa Clara", "4949 Great America Pkwy, Santa Clara, CA 95054"),
        ("Hotel DeAnza", "21250 Stevens Creek Blvd, Cupertino, CA 95014"),
        ("Hyatt Santa Clara", "5101 Great America Pkwy, Santa Clara, CA 95054"),
        ("Hyatt Place San Jose", "282 S Almaden Blvd, San Jose, CA 95113"),
        ("Marriott San Jose", "301 S Market St, San Jose, CA 95113")
    ]
            
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.delegate = self
        searchController.searchBar.searchBarStyle = UISearchBarStyle.Minimal
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.showsCancelButton = false
        
        let attributes:[String:AnyObject] = [
            NSFontAttributeName : UIFont(name: "HelveticaNeue-Thin", size: CGFloat(12.0))!
        ]
        UIBarButtonItem.appearanceWhenContainedInInstancesOfClasses([UISearchBar.self]).setTitleTextAttributes(attributes, forState: .Normal)
        
        searchController.searchBar.setScopeBarButtonTitleTextAttributes(attributes, forState:.Normal)

        tableView.tableHeaderView = searchController.searchBar;
    }
        
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let row = indexPath.row
        let fullLabel = arrayOfHotelNames[row].0.uppercaseString
        let partialLabel = searchController.searchBar.text!.uppercaseString
        if (fullLabel.rangeOfString(partialLabel) == nil)
        {
            return 0
        }
        else
        {
            return 20
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Hotel", forIndexPath: indexPath)
        let row = indexPath.row
        cell.textLabel?.text = arrayOfHotelNames[row].0
        cell.textLabel?.font = UIFont(name: "HelveticaNeue-Thin", size: CGFloat(10.0))
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        searchController.searchBar.text = arrayOfHotelNames[indexPath.row].0
        mapController.gotoName(arrayOfHotelNames[indexPath.row].1) {
            (error) -> () in
        }
    }

    func updateSearchResultsForSearchController(searchController: UISearchController) {
        tableView.reloadData()
        heightConstraint.constant = tableView.contentSize.height
        
        var frame = view.frame
        frame.size.height = tableView.contentSize.height
        view.frame = frame
    }
}
