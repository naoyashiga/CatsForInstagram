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

class FavoriteCollectionViewController: PhotoCollectionViewController, UIViewControllerTransitioningDelegate {
    private var favorites: Results<Favorite> {
        get {
            let realm = Realm()
            //新しい順に並べる
            return realm.objects(Favorite).sorted("createdAt", ascending: false)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if let collectionView = collectionView {
            collectionView.emptyDataSetDelegate = self
            collectionView.emptyDataSetSource = self
            
            collectionView.applyCellNib(cellNibName: favoriteReuseId.cell)
        }
    }
    
    func openReviewModal() {
        let reviewVC = ReviewViewController(nibName: "ReviewViewController", bundle: nil)
        reviewVC.modalPresentationStyle = .Custom
        reviewVC.transitioningDelegate = self
        presentViewController(reviewVC, animated: true, completion: nil)
    }
    
    func presentationControllerForPresentedViewController(presented: UIViewController, presentingViewController presenting: UIViewController!, sourceViewController source: UIViewController) -> UIPresentationController? {
        
        return BlurredBackgroundPresentationController(presentedViewController: presented, presentingViewController: source)
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
        
        openReviewModal()
    }
}