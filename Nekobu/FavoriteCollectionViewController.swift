//
//  FavoriteCollectionViewController.swift
//  Nekobu
//
//  Created by naoyashiga on 2015/08/15.
//  Copyright (c) 2015年 naoyashiga. All rights reserved.
//

import UIKit
import WebImage
import RealmSwift

struct favoriteReuseId {
    static let cell = "FavoriteCollectionViewCell"
}

class FavoriteCollectionViewController: PhotoCollectionViewController {
    private var favorites: Results<Favorite> {
        get {
            do {
                let realm = try Realm()
                //新しい順に並べる
                return realm.objects(Favorite).sorted("createdAt", ascending: false)
                
            } catch {
                fatalError("cant set favorites FavoriteCollectionViewController")
            }
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
        
        let favorite = favorites[indexPath.row]
        let favoriteDetailVC = FavoriteDetailViewController(nibName: "PhotoDetailViewController", bundle: nil)
        favoriteDetailVC.modalPresentationStyle = .Custom
        favoriteDetailVC.transitioningDelegate = self
        
        favoriteDetailVC.favorite = favorite
        
        view.window?.rootViewController?.presentViewController(favoriteDetailVC, animated: true, completion: nil)
    }
    
}