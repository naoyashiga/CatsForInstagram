//
//  PresentationManager.swift
//  Nekobu
//
//  Created by naoyashiga on 2015/08/15.
//  Copyright (c) 2015年 naoyashiga. All rights reserved.
//

import UIKit

@objc public protocol RPZoomTransitionAnimating {
    func calculatedPositionSourceImageView() -> UIImageView
    func sourceImageView() -> UIImageView
    func transitionDestinationImageViewFrame() -> CGRect
}

//class PresentationManager: NSObject, UIViewControllerTransitioningDelegate {
//    
//    func presentationControllerForPresentedViewController(presented: UIViewController, presentingViewController presenting: UIViewController!, sourceViewController source: UIViewController) -> UIPresentationController? {
//        return BlurredBackgroundPresentationController(presentedViewController: presented, presentingViewController: source)
//    }
//    
//    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
//        
//        let animator = TransitionPresentationAnimator()
//        animator.sourceVC = source
//        animator.destinationVC = presented
//        
//        return TransitionPresentationAnimator()
//    }
//    
//    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
//        return TransitionDismissAnimator()
//    }
//}
