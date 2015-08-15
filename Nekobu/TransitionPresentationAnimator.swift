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
    
    let kForwardAnimationDuration: NSTimeInterval = 0.3
    let kForwardCompleteAnimationDuration: NSTimeInterval = 0.3
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning) -> NSTimeInterval {
        return 0.3
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
        
        UIView.animateWithDuration(kForwardAnimationDuration, delay: 0, options: .CurveEaseOut, animations: {
            sourceImageView.frame = destinationImageViewFrame
            
            }, completion: {(finished: Bool) in
                if finished {
                    destinationImageView.hidden = false
                    sourceImageView.removeFromSuperview()
                }
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
        })
        
//        let toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!
//        let containerView = transitionContext.containerView()
//        
//        let animationDuration = transitionDuration(transitionContext)
//        
//        toViewController.view.transform = CGAffineTransformMakeScale(0.1, 0.1)
//        toViewController.view.layer.shadowColor = UIColor.blackColor().CGColor
//        toViewController.view.layer.shadowOffset = CGSizeMake(0.0, 2.0)
//        toViewController.view.layer.shadowOpacity = 0.3
//        toViewController.view.layer.cornerRadius = 4.0
//        toViewController.view.clipsToBounds = true
//        
//        containerView.addSubview(toViewController.view)
//        
//        UIView.animateWithDuration(
//            animationDuration,
//            animations: {
//                
//            toViewController.view.transform = CGAffineTransformIdentity
//                
//            }, completion: { finished in
//                transitionContext.completeTransition(finished)
//        })
    }
}
