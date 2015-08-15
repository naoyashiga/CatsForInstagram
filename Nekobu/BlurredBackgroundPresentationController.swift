//
//  BlurredBackgroundPresentationController.swift
//  Nekobu
//
//  Created by naoyashiga on 2015/08/15.
//  Copyright (c) 2015年 naoyashiga. All rights reserved.
//

import UIKit

class BlurredBackgroundPresentationController: UIPresentationController {
    var dimmingView: UIView!
    
    override init(presentedViewController: UIViewController!, presentingViewController: UIViewController!) {
        super.init(presentedViewController: presentedViewController, presentingViewController: presentingViewController)
        setupDimmingView()
    }
    
    func setupDimmingView() {
        dimmingView = UIView()
        var visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .Light)) as UIVisualEffectView
        visualEffectView.frame = dimmingView.bounds
        visualEffectView.autoresizingMask = .FlexibleHeight | .FlexibleWidth
        dimmingView.addSubview(visualEffectView)
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: "dimmingViewTapped:")
        dimmingView.addGestureRecognizer(tapRecognizer)
    }
    
    func dimmingViewTapped(tapRecognizer: UITapGestureRecognizer) {
        presentingViewController.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    override func containerViewWillLayoutSubviews() {
        dimmingView.frame = containerView.bounds
        presentedView().frame = frameOfPresentedViewInContainerView()
        presentedView().layer.borderWidth = 0.0
    }
    
    override func frameOfPresentedViewInContainerView() -> CGRect {//
        var containerBounds:CGRect = self.containerView.bounds
        var presentedViewFrame = CGRectZero
        var width:CGFloat = containerBounds.size.width * 0.75
        var height:CGFloat = containerBounds.size.height  * 0.25 // TODO: hard coded
        presentedViewFrame.size = CGSizeMake(width,height)
        presentedViewFrame.origin = CGPointMake(containerBounds.size.width / 2.0, containerBounds.size.height / 2.0)
        presentedViewFrame.origin.x -= presentedViewFrame.size.width / 2.0;
        presentedViewFrame.origin.y -= presentedViewFrame.size.height / 2.0;
        return presentedViewFrame
    }
    
    override func presentationTransitionWillBegin() {
        self.dimmingView.alpha = 0.0
        let containerView = self.containerView
        dimmingView.frame = containerView.bounds
        dimmingView.alpha = 0.0
        containerView.insertSubview(dimmingView, atIndex: 0)
        
        presentedViewController.transitionCoordinator()?.animateAlongsideTransition({ (context) -> Void in
            self.dimmingView.alpha = 1.0
            }, completion: nil)
    }
    
    override func dismissalTransitionWillBegin() {
        presentedViewController.transitionCoordinator()?.animateAlongsideTransition({ (context) -> Void in
            self.dimmingView.alpha = 0.0
            }, completion: nil)
    }
}
