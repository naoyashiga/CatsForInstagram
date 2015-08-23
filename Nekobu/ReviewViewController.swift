//
//  ReviewViewController.swift
//  Nekobu
//
//  Created by naoyashiga on 2015/08/21.
//  Copyright (c) 2015年 naoyashiga. All rights reserved.
//

import UIKit

class ReviewViewController: UIViewController {
    @IBOutlet var reviewTextImageView: UIImageView!
    @IBOutlet var cancelButton: UIButton!
    @IBOutlet var reviewButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func openAppStore(urlStr:String){
        let url = NSURL(string:urlStr)
        UIApplication.sharedApplication().openURL(url!)
    }
    
    func transitionToReviewPage() {
        let reviewURL = AppConstraints.reviewURLString + AppConstraints.appID
        
        openAppStore(reviewURL)
    }
    
    @IBAction func reviewButtonTapped(sender: UIButton) {
        transitionToReviewPage()
        
        ReviewManager.updateReviewStatus()
    }
    
    @IBAction func cacelButtonTapped(sender: UIButton) {
        presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
