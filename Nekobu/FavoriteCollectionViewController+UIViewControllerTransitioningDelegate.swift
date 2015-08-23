//
//  FavoriteCollectionViewController+UIViewControllerTransitioningDelegate.swift
//  Nekobu
//
//  Created by naoyashiga on 2015/08/23.
//  Copyright (c) 2015年 naoyashiga. All rights reserved.
//

import Foundation

extension FavoriteCollectionViewController: UIViewControllerTransitioningDelegate {

    func presentationControllerForPresentedViewController(presented: UIViewController, presentingViewController presenting: UIViewController!, sourceViewController source: UIViewController) -> UIPresentationController? {
        
        return BlurredBackgroundPresentationController(presentedViewController: presented, presentingViewController: self)
    }
    
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        let animator = TransitionPresentationAnimator()
        animator.sourceVC = self
        animator.destinationVC = presented
        
        return animator
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        let animator = TransitionDismissAnimator()
        animator.sourceVC = dismissed
        animator.destinationVC = self
        
        return animator
    }
}