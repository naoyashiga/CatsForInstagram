//
//  TransitionPresentationAnimator.swift
//  Nekobu
//
//  Created by naoyashiga on 2015/08/15.
//  Copyright (c) 2015年 naoyashiga. All rights reserved.
//

import UIKit

class TransitionPresentationAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    var sourceVC = UIViewController()
    var destinationVC = UIViewController()
    
    let kForwardAnimationDuration: NSTimeInterval = 0.4
    let kForwardCompleteAnimationDuration: NSTimeInterval = 0.4
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning) -> NSTimeInterval {
        return kForwardAnimationDuration
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        let containerView = transitionContext.containerView()
        let toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!
        
        var sourceImageView = UIImageView()
        var destinationImageView = UIImageView()
        var destinationImageViewFrame = CGRect()
        
        toViewController.view.frame = transitionContext.finalFrameForViewController(toViewController)
        
        containerView.addSubview(toViewController.view)
        
        toViewController.view.setNeedsLayout()
        toViewController.view.layoutIfNeeded()
        
        if let sourceViewController = sourceVC as? RPZoomTransitionAnimating {
            sourceImageView.image = sourceViewController.transitionSourceImageView().image
            sourceImageView.frame = sourceViewController.transitionSourceImageView().frame
            containerView.addSubview(sourceImageView)
        }
        
        if let destinationViewController = destinationVC as? RPZoomTransitionAnimating {
            destinationImageView = destinationViewController.transitionSourceImageView()
            destinationImageView.hidden = true
            
            destinationImageViewFrame = destinationViewController.transitionDestinationImageViewFrame()
        }
        
        UIView.animateWithDuration(
            kForwardCompleteAnimationDuration,
            delay: 0,
            usingSpringWithDamping: 3.4,
            initialSpringVelocity: 0,
            options: .CurveEaseOut,
            animations: {
                sourceImageView.frame = destinationImageViewFrame
                
            }, completion: { finished in
                if finished {
                    destinationImageView.hidden = false
                    sourceImageView.removeFromSuperview()
                }
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
        })
    }
}
