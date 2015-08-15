//
//  PhotoDetailViewController.swift
//  Nekobu
//
//  Created by naoyashiga on 2015/08/15.
//  Copyright (c) 2015年 naoyashiga. All rights reserved.
//

import UIKit

class PhotoDetailViewController: UIViewController, RPZoomTransitionAnimating {
    @IBOutlet var detailImageView: UIImageView!
    var detailImageURL: NSURL?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.layer.cornerRadius = 10.0
        view.clipsToBounds = true
        
        detailImageView.sd_setImageWithURL(detailImageURL)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func favoriteButtonTapped(sender: UIButton) {
        
    }
    
    @IBAction func shareButtonTapped(sender: UIButton) {
        
    }
    
    @IBAction func dismissButtonTapped(sender: UIButton) {
        presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func transitionSourceImageView() -> UIImageView {
        return detailImageView
    }
    
    func transitionSourceBackgroundColor() -> UIColor {
        return view.backgroundColor!
    }
    
    func transitionDestinationImageViewFrame() -> CGRect {
        let calculatedFrame = CGRectMake(view.frame.origin.x, view.frame.origin.y, detailImageView.frame.width, detailImageView.frame.height)
        return calculatedFrame
    }
}
