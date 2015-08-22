//
//  FavoriteCollectionViewController.swift
//  Nekobu
//
//  Created by naoyashiga on 2015/08/15.
//  Copyright (c) 2015年 naoyashiga. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import WebImage
import RealmSwift

struct favoriteReuseId {
    static let cell = "FavoriteCollectionViewCell"
}

class FavoriteCollectionViewController: PhotoCollectionViewController, UIViewControllerTransitioningDelegate, RPZoomTransitionAnimating {
    private var favorites: Results<Favorite> {
        get {
            let realm = Realm()
            //新しい順に並べる
            return realm.objects(Favorite).sorted("createdAt", ascending: false)
        }
    }
    
    var selectedIndexPath = NSIndexPath()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if let collectionView = collectionView {
            collectionView.emptyDataSetDelegate = self
            collectionView.emptyDataSetSource = self
            
            collectionView.applyCellNib(cellNibName: favoriteReuseId.cell)
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return favorites.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(favoriteReuseId.cell, forIndexPath: indexPath) as! FavoriteCollectionViewCell
    
        let favorite = favorites[indexPath.row]
        cell.thumbNailImageView.image = favorite.lowResolutionBase64ImageString.String2Image()
        
//        let imageCache = SDImageCache(namespace: "sampleCache")
//        SDWebImageManager.sharedManager().imageCache.queryDiskCacheForKey(favorite.lowResolutionImageURLString
//            , done: { (image: UIImage!, type: SDImageCacheType) -> Void in
//                
//                cell.thumbNailImageView.image = image
//        })
        
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(favoriteReuseId.cell, forIndexPath: indexPath) as! FavoriteCollectionViewCell
        
//        openReviewModal()
        
        let favorite = favorites[indexPath.row]
        let favoriteDetailVC = FavoriteDetailViewController(nibName: "PhotoDetailViewController", bundle: nil)
        favoriteDetailVC.modalPresentationStyle = .Custom
        favoriteDetailVC.transitioningDelegate = self
        
        favoriteDetailVC.favorite = favorite
        
//        photoDetailVC.detailImageURL = media.standardResolutionImageURL
//        photoDetailVC.media = media
        
        view.window?.rootViewController?.presentViewController(favoriteDetailVC, animated: true, completion: nil)
    }
    
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
    
    //MARK: RPZoomTransitionAnimating
    func sourceImageView() -> UIImageView {
        //使用しない
        return UIImageView()
    }
    
    func calculatedPositionSourceImageView() -> UIImageView {
        if let selectedIndexPath = collectionView?.indexPathsForSelectedItems().first as? NSIndexPath {
            self.selectedIndexPath = selectedIndexPath
        }
        
        let cell = collectionView?.cellForItemAtIndexPath(self.selectedIndexPath) as! FavoriteCollectionViewCell
        let imageView = UIImageView(image: cell.thumbNailImageView.image)
        
        imageView.contentMode = cell.thumbNailImageView.contentMode
        imageView.clipsToBounds = true
        imageView.userInteractionEnabled = false
        imageView.frame = cell.thumbNailImageView.convertRect(cell.thumbNailImageView.frame, toView: collectionView?.superview)
        
        imageView.frame = CGRectMake(imageView.frame.origin.x, imageView.frame.origin.y + PageMenuConstraint.menuHeight, imageView.frame.size.width, imageView.frame.size.height)
        return imageView
    }
    
    func transitionDestinationImageViewFrame() -> CGRect {
        let cell = collectionView?.cellForItemAtIndexPath(selectedIndexPath) as! FavoriteCollectionViewCell
        let cellFrameInSuperview = cell.thumbNailImageView.convertRect(cell.thumbNailImageView.frame, toView: collectionView?.superview)
        
        let resizedCellFrameInSuperview = CGRectMake(cellFrameInSuperview.origin.x, cellFrameInSuperview.origin.y + PageMenuConstraint.menuHeight, cellFrameInSuperview.size.width, cellFrameInSuperview.size.height)
        
        return resizedCellFrameInSuperview
    }
}