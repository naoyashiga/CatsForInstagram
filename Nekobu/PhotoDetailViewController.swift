//
//  PhotoDetailViewController.swift
//  Nekobu
//
//  Created by naoyashiga on 2015/08/15.
//  Copyright (c) 2015年 naoyashiga. All rights reserved.
//

import UIKit
import RealmSwift

class PhotoDetailViewController: UIViewController, RPZoomTransitionAnimating {
    @IBOutlet var detailImageView: UIImageView!
    
    var detailImageURL: NSURL?
    var media = Media()
    
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
        let favorite = Favorite()
        favorite.id = media.id
        
        if let url = media.lowResolutionImageURL {
            favorite.lowResolutionImageURLString = url.absoluteString!
        }
        
        if let url = media.standardResolutionImageURL {
            favorite.standardResolutionImageURLString = url.absoluteString!
        }
        
        favorite.createdAt = NSDate().timeIntervalSince1970
        
        let realm = Realm()
        
        realm.write {
            println("add fav")
            realm.add(favorite, update: true)
        }
        
    }
    
    @IBAction func shareButtonTapped(sender: UIButton) {
        
    }
    
    @IBAction func dismissButtonTapped(sender: UIButton) {
        presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func sourceImageView() -> UIImageView {
        return detailImageView
    }
    
    func calculatedPositionSourceImageView() -> UIImageView {
        let calculatedImageView = UIImageView()
        calculatedImageView.image = detailImageView.image
        calculatedImageView.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y, detailImageView.frame.width, detailImageView.frame.height)
        return calculatedImageView
    }
    
    func transitionDestinationImageViewFrame() -> CGRect {
        let calculatedFrame = CGRectMake(view.frame.origin.x, view.frame.origin.y, detailImageView.frame.width, detailImageView.frame.height)
        return calculatedFrame
    }
}
