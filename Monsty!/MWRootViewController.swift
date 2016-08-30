//
//  MWRootViewController.swift
//  Monsty!
//
//  Created by dyashe on 8/27/16.
//  Copyright © 2016 monstyware. All rights reserved.
//

import UIKit

class MWRootViewController: UIViewController  {
    
    var reservationController: MWReservationController!
    var mapController: MWMapController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserverForName(mapViewDidFinishRenderingMapKey, object: nil, queue: nil) {
            (note:NSNotification!) in
            if (self.reservationController == nil) {
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                self.reservationController = storyboard.instantiateViewControllerWithIdentifier("MWReservationController") as! MWReservationController
                self.reservationController.mapController = self.mapController;
                
                self.addChildViewAndController(self.reservationController)
                
                var frame = self.reservationController.view.frame
                frame.origin.y = -(self.reservationController.heightConstraint.constant)
                frame.size.height = self.reservationController.heightConstraint.constant
                frame.size.width = self.view.frame.size.width
                self.reservationController.view.frame = frame
                self.reservationController.view.layoutIfNeeded()
                
                UIView.animateWithDuration(0.25, delay:0.0, options:UIViewAnimationOptions.CurveEaseInOut, animations: {
                    frame = self.reservationController.view.frame
                    frame.origin.y = self.reservationController.heightConstraint.constant
                    self.reservationController.view.frame = frame
                    }, completion: {
                        (value: Bool) in
                })
            }
        }
    }
    
    func addChildViewAndController(childController: UIViewController) {
        self.addChildViewAndController(childController, intoView: view)
    }
    
    func addChildViewAndController(childController: UIViewController, intoView: UIView) {
        self.addChildViewAndController(childController, intoView:intoView, withFrame:intoView.bounds)
    }
    
    func addChildViewAndController(childController: UIViewController, intoView:UIView, withFrame:CGRect) {
        addChildViewController(childController)
        self.view.addSubview(childController.view)
        childController.view.frame = withFrame;
        childController.didMoveToParentViewController(self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "MapSegue" {
            mapController =  segue.destinationViewController as! MWMapController
         }
    }
}

