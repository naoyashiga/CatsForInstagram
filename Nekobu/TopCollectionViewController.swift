//
//  TopCollectionViewController.swift
//  Nekobu
//
//  Created by naoyashiga on 2015/08/15.
//  Copyright (c) 2015年 naoyashiga. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import WebImage

struct topReuseId {
    static let cell = "TopCollectionViewCell"
//    static let headerView = "HomeHeaderView"
}

class TopCollectionViewController: BaseCollectionViewController, UIViewControllerTransitioningDelegate {
    var mediaList = [Media]() {
        didSet {
            collectionView?.reloadData()
        }
    }
    
    var selectedIndexPath = NSIndexPath()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.applyCellNib(cellNibName: topReuseId.cell)

        Alamofire.request(.GET, Config.TAG).responseSwiftyJSON({ (_, _, json, error) in
            if (error != nil) {
                println("Error with registration: \(error?.localizedDescription)")
            } else {
                if let array = json["data"].array {
                    
                    for d in array {
                        var media = Media(
                            thumbNailURL: d["images"]["thumbnail"]["url"].URL,
                            standardImageURL: d["images"]["standard_resolution"]["url"].URL
                        )
                        
                        self.mediaList.append(media)
                    }
                }
            }
        })
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mediaList.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(topReuseId.cell, forIndexPath: indexPath) as! TopCollectionViewCell
    
        let media = mediaList[indexPath.row]
        cell.thumbNailImageView.loadingImageBySDWebImage(media)
    
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(topReuseId.cell, forIndexPath: indexPath) as! TopCollectionViewCell
        
        let media = mediaList[indexPath.row]
        let photoDetailVC = PhotoDetailViewController(nibName: "PhotoDetailViewController", bundle: nil)
        photoDetailVC.modalPresentationStyle = .Custom
//        photoDetailVC.transitioningDelegate = PresentationManager()
        photoDetailVC.transitioningDelegate = self
        photoDetailVC.detailImageURL = media.standardImageURL
        
        presentViewController(photoDetailVC, animated: true, completion: nil)
    }
    
    func presentationControllerForPresentedViewController(presented: UIViewController, presentingViewController presenting: UIViewController!, sourceViewController source: UIViewController) -> UIPresentationController? {
//        return BlurredBackgroundPresentationController(presentedViewController: presented, presentingViewController: presenting)
        return BlurredBackgroundPresentationController(presentedViewController: presented, presentingViewController: source)
    }
    
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return TransitionPresentationAnimator()
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return TransitionDismissAnimator()
    }
}
