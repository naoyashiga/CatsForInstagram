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
import GoogleMobileAds

struct topReuseId {
    static let cell = "TopCollectionViewCell"
}

class TopCollectionViewController: PhotoCollectionViewController {
    var mediaList = [Media]() {
        didSet {
//            collectionView?.reloadData()
        }
    }
    
    var pagenation = Pagenation(nextURLString: "")
    
    var selectedIndexPath = NSIndexPath()
    
    var interstitial:GADInterstitial?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let collectionView = collectionView {
            collectionView.applyCellNib(cellNibName: topReuseId.cell)
        }

        settingInterstitialAd()
        settingAd()
        
        loadPhoto(requestURL: Config.TAG)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func loadPhoto(requestURL requestURL: String) {
        Alamofire.request(.GET, requestURL).responseSwiftyJSON({ (_, _, json, error) in
            if (error != nil) {
                print("Error with registration: \(error?.localizedDescription)")
            } else {
//                println(json)
                if let array = json["data"].array {
                    
                    for d in array {
                        
                        let media: Media
                        
                        if d["type"].string == "image" {
                            media = Media(
                                type: "image",
                                id: d["id"].stringValue,
                                lowResolutionImageURL: d["images"]["low_resolution"]["url"].URL,
                                standardResolutionImageURL: d["images"]["standard_resolution"]["url"].URL,
                                lowResolutionBase64ImageString: "",
                                standardResolutionBase64ImageString: "",
                                webPageLinkString: d["link"].stringValue,
                                video: nil
                            )
                            
                            self.mediaList.append(media)
                            
                        }
                    }
                }
                
                
                if let nextURLString = json["pagination"]["next_url"].string {
                    self.pagenation = Pagenation(nextURLString: nextURLString)
                }
                
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
        
//        if let thumbNailImageURL = media.standardResolutionImageURL {
//            cell.thumbNailImageView.loadingImageBySDWebImage(thumbNailImageURL) { loadedImage in
//                self.mediaList[indexPath.row].standardResolutionBase64ImageString = loadedImage.Image2String()
//            }
//        }
        
        // 低画質画像を読みこみ、表示
        if let thumbNailImageURL = media.lowResolutionImageURL {
            cell.thumbNailImageView.loadingImageBySDWebImage(thumbNailImageURL) { loadedImage in
                self.mediaList[indexPath.row].lowResolutionBase64ImageString = loadedImage.Image2String()
            }
        }
        
        if indexPath.row == mediaList.count - 4 {
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
        
        photoDetailVC.media = media
        
        //レビュー訴求
        
        if(ReviewManager.isReview){
            //レビューまだの人
            if(ReviewManager.counter != 0 && ReviewManager.counter % ReviewManager.Cycle.top == 0){
                let reviewVC = ReviewViewController(nibName: "ReviewViewController", bundle: nil)
                reviewVC.modalPresentationStyle = .Custom
                reviewVC.transitioningDelegate = self
                view.window?.rootViewController?.presentViewController(reviewVC, animated: true, completion: nil)
            } else {
                //レビューをしていない人は広告が出る
                checkInterstitialAd(photoDetailViewController: photoDetailVC)
            }
            
            ReviewManager.countUp(ReviewManager.keyName.reviewCounter)
            
        } else {
            view.window?.rootViewController?.presentViewController(photoDetailVC, animated: true, completion: nil)
        }
    }
    
}
