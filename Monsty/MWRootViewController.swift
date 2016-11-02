//
//  MWRootViewController.swift
//  Monsty!
//
//  Created by dyashe on 8/27/16.
//  Copyright © 2016 monstyware. All rights reserved.
//

import UIKit

class MWRootViewController: UIViewController  {

    @IBOutlet weak var reservationContainer: UIView!
    @IBOutlet weak var reservationTopConstraint: NSLayoutConstraint!
    
    var mapController: MWMapController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        reservationTopConstraint.constant = -150.0
        self.view.updateConstraintsIfNeeded()

        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: mapViewDidFinishRenderingMapKey), object:nil, queue:nil) {
            (note:Notification!) in
            
            DispatchQueue.main.async { [unowned self] in
                UIView.animate(withDuration: 1.0, delay:0.0, options:UIViewAnimationOptions(), animations: {
                    self.reservationTopConstraint.constant = 40.0
                    self.view.updateConstraintsIfNeeded()
                    }, completion:nil)
            }
         }
    }
    
    func addChildViewAndController(_ childController: UIViewController) {
        self.addChildViewAndController(childController, intoView: view)
    }
    
    func addChildViewAndController(_ childController: UIViewController, intoView: UIView) {
        self.addChildViewAndController(childController, intoView:intoView, withFrame:intoView.bounds)
    }
    
    func addChildViewAndController(_ childController: UIViewController, intoView:UIView, withFrame:CGRect) {
        addChildViewController(childController)
        self.view.addSubview(childController.view)
        childController.view.frame = withFrame;
        childController.didMove(toParentViewController: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "MapSegue" {
            mapController =  segue.destination as! MWMapController
         }
    }
}

