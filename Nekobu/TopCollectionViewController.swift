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
}

class TopCollectionViewController: BaseCollectionViewController, UIViewControllerTransitioningDelegate, RPZoomTransitionAnimating {
    var mediaList = [Media]() {
        didSet {
//            collectionView?.reloadData()
        }
    }
    
    var pagenation = Pagenation(nextURLString: "")
    
    var selectedIndexPath = NSIndexPath()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.viewBackgroundColor()
        
        collectionView?.applyCellNib(cellNibName: topReuseId.cell)

        
        loadPhoto(requestURL: Config.TAG)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadPhoto(#requestURL: String) {
        Alamofire.request(.GET, requestURL).responseSwiftyJSON({ (_, _, json, error) in
            if (error != nil) {
                println("Error with registration: \(error?.localizedDescription)")
            } else {
//                println(json)
                if let array = json["data"].array {
                    
                    for d in array {
                        var media = Media(
                            lowResolutionImageURL: d["images"]["low_resolution"]["url"].URL,
                            standardResolutionImageURL: d["images"]["standard_resolution"]["url"].URL
                        )
                        
                        self.mediaList.append(media)
                    }
                }
                
                
                if let nextURLString = json["pagination"]["next_url"].string {
                    self.pagenation = Pagenation(nextURLString: nextURLString)
                }
                
                println("reload")
                self.collectionView?.reloadData()
            }
        })
        
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
        
        if indexPath.row == mediaList.count - 1 {
            println("end contents")
            loadPhoto(requestURL: pagenation.nextURLString)
        }
    
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(topReuseId.cell, forIndexPath: indexPath) as! TopCollectionViewCell
        
        let media = mediaList[indexPath.row]
        let photoDetailVC = PhotoDetailViewController(nibName: "PhotoDetailViewController", bundle: nil)
        photoDetailVC.modalPresentationStyle = .Custom
        photoDetailVC.transitioningDelegate = self
        
        photoDetailVC.detailImageURL = media.standardResolutionImageURL
        
        presentViewController(photoDetailVC, animated: true, completion: nil)
    }
    
    func presentationControllerForPresentedViewController(presented: UIViewController, presentingViewController presenting: UIViewController!, sourceViewController source: UIViewController) -> UIPresentationController? {
        
        return BlurredBackgroundPresentationController(presentedViewController: presented, presentingViewController: source)
    }
    
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        let animator = TransitionPresentationAnimator()
        animator.sourceVC = source
        animator.destinationVC = presented
        
        return animator
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        let animator = TransitionDismissAnimator()
        animator.sourceVC = dismissed
        animator.destinationVC = self
        
        return animator
    }
    
    //MARK: RPZoomTransitionAnimating
    func sourceImageView() -> UIImageView {
        //使用しない
        return UIImageView()
    }
    
    func calculatedPositionSourceImageView() -> UIImageView {
        if let selectedIndexPath = collectionView?.indexPathsForSelectedItems().first as? NSIndexPath {
            self.selectedIndexPath = selectedIndexPath
        }
        
        let cell = collectionView?.cellForItemAtIndexPath(self.selectedIndexPath) as! TopCollectionViewCell
        let imageView = UIImageView(image: cell.thumbNailImageView.image)
        
        imageView.contentMode = cell.thumbNailImageView.contentMode
        imageView.clipsToBounds = true
        imageView.userInteractionEnabled = false
        imageView.frame = cell.thumbNailImageView.convertRect(cell.thumbNailImageView.frame, toView: collectionView?.superview)
        return imageView
    }
    
    func transitionDestinationImageViewFrame() -> CGRect {
        let cell = collectionView?.cellForItemAtIndexPath(selectedIndexPath) as! TopCollectionViewCell
        let cellFrameInSuperview = cell.thumbNailImageView.convertRect(cell.thumbNailImageView.frame, toView: collectionView?.superview)
        
        let resizedCellFrameInSuperview = CGRectMake(cellFrameInSuperview.origin.x, cellFrameInSuperview.origin.y + PageMenuConstraint.menuHeight, cellFrameInSuperview.size.width, cellFrameInSuperview.size.height)
        
        return resizedCellFrameInSuperview
    }
}
