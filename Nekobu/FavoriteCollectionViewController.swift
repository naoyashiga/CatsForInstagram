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

class FavoriteCollectionViewController: BaseCollectionViewController {
    private var favorites: Results<Favorite> {
        get {
            let realm = Realm()
            //新しい順に並べる
            return realm.objects(Favorite).sorted("createdAt", ascending: false)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.applyCellNib(cellNibName: favoriteReuseId.cell)
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
        let thumbNailImageURL = NSURL(string: favorite.lowResolutionImageURLString)
        
        if let thumbNailImageURL = thumbNailImageURL {
            cell.thumbNailImageView.loadingImageBySDWebImage(thumbNailImageURL)
        }
        
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(favoriteReuseId.cell, forIndexPath: indexPath) as! FavoriteCollectionViewCell
    }
}