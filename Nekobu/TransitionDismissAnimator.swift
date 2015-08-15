//
//  TransitionDismissAnimator.swift
//  Nekobu
//
//  Created by naoyashiga on 2015/08/15.
//  Copyright (c) 2015年 naoyashiga. All rights reserved.
//

import Foundation
import UIKit

class TransitionDismissAnimator : NSObject, UIViewControllerAnimatedTransitioning {
    var sourceVC = UIViewController()
    var destinationVC = UIViewController()
    
    let kBackwardAnimationDuration: NSTimeInterval = 0.4
    let kBackwardCompleteAnimationDuration: NSTimeInterval = 0.4
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning) -> NSTimeInterval {
        return kBackwardAnimationDuration
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        let containerView = transitionContext.containerView()
        let fromVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!
        
        let sourceImageView = UIImageView()
        var destinationImageView = UIImageView()
        var destinationImageViewFrame = CGRect()
        
        containerView.addSubview(fromVC.view)
        
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
            kBackwardCompleteAnimationDuration,
            delay: 0,
            usingSpringWithDamping: 3.4,
            initialSpringVelocity: 0,
            options: .CurveEaseOut,
            animations: {
                sourceImageView.frame = destinationImageViewFrame
                
                fromVC.view.alpha = 0.0
            
            }, completion: {finished in
                if finished {
                    destinationImageView.removeFromSuperview()
                    sourceImageView.removeFromSuperview()
                }
                
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
        })
    }
}
