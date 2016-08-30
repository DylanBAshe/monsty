//
//  MWReservationSegue.swift
//  Monsty!
//
//  Created by dyashe on 8/28/16.
//  Copyright © 2016 monstyware. All rights reserved.
//

import UIKit

class MWReservationSegue: UIStoryboardSegue  {
    override func perform () {
        let src = self.sourceViewController as UIViewController
        let dst = self.destinationViewController as! MWReservationController
        src.addChildViewController(dst)
        dst.view.alpha = 1.0
        src.view.addSubview(dst.view)
        dst.didMoveToParentViewController(src)
        UIView.animateWithDuration(1.0, delay:0.0, options:UIViewAnimationOptions.CurveEaseInOut, animations: {
                dst.view.alpha = 0.0
            }, completion:nil)
    }
}
