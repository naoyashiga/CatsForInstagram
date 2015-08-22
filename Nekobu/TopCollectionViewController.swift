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

class TopCollectionViewController: PhotoCollectionViewController, UIViewControllerTransitioningDelegate, RPZoomTransitionAnimating, GADBannerViewDelegate {
    var mediaList = [Media]() {
        didSet {
//            collectionView?.reloadData()
        }
    }
    
    var pagenation = Pagenation(nextURLString: "")
    
    var selectedIndexPath = NSIndexPath()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let collectionView = collectionView {
            collectionView.applyCellNib(cellNibName: topReuseId.cell)
        }

        settingAd()
        
        loadPhoto(requestURL: Config.TAG)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        println("WebviewControllerは正しく解放されました")
    }
    func settingAd(){
        let MY_BANNER_UNIT_ID = "ca-app-pub-9360978553412745/9261475110"
        
        var origin = CGPointMake(
            0.0,
            view.bounds.height - CGSizeFromGADAdSize(kGADAdSizeBanner).height - PageMenuConstraint.menuHeight)
        
        var size = GADAdSizeFullWidthPortraitWithHeight(50) // set size to 50
        var adB = GADBannerView(adSize: size, origin: origin) // create the banner
        adB.adUnitID = MY_BANNER_UNIT_ID  //"ca-app-pub-XXXXXXXX/XXXXXXX"
        adB.delegate = self // ??
        adB.rootViewController = self // ??
        self.view.addSubview(adB) // ??
        var request = GADRequest() // create request
//        request.testDevices = [kGADSimulatorID]
        request.testDevices = ["0b0df889514cace63baf0d3f248e5295"]
        adB.loadRequest(request) // actually load it (?)
    }
    
    func loadPhoto(#requestURL: String) {
        Alamofire.request(.GET, requestURL).responseSwiftyJSON({ (_, _, json, error) in
            if (error != nil) {
                println("Error with registration: \(error?.localizedDescription)")
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
                                video: nil
                            )
                            
                            self.mediaList.append(media)
                            
                        } else if d["type"].string == "video" {
//                            let video = Video(
//                                lowResolutionVideoURL: d["videos"]["low_resolution"]["url"].URL,
//                                standardResolutionVideoURL: d["videos"]["standard_resolution"]["url"].URL
//                                )
//                            
//                            media = Media(
//                                type: "video",
//                                lowResolutionImageURL: d["images"]["low_resolution"]["url"].URL,
//                                standardResolutionImageURL: d["images"]["standard_resolution"]["url"].URL,
//                                video: video
//                            )
//                            
//                            self.mediaList.append(media)
                        }
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
        
        if indexPath.row == mediaList.count - 2 {
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
        photoDetailVC.media = media
        
        view.window?.rootViewController?.presentViewController(photoDetailVC, animated: true, completion: nil)
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
        
        let cell = collectionView?.cellForItemAtIndexPath(self.selectedIndexPath) as! TopCollectionViewCell
        let imageView = UIImageView(image: cell.thumbNailImageView.image)
        
        imageView.contentMode = cell.thumbNailImageView.contentMode
        imageView.clipsToBounds = true
        imageView.userInteractionEnabled = false
        imageView.frame = cell.thumbNailImageView.convertRect(cell.thumbNailImageView.frame, toView: collectionView?.superview)
        
        imageView.frame = CGRectMake(imageView.frame.origin.x, imageView.frame.origin.y + PageMenuConstraint.menuHeight, imageView.frame.size.width, imageView.frame.size.height)
        return imageView
    }
    
    func transitionDestinationImageViewFrame() -> CGRect {
        let cell = collectionView?.cellForItemAtIndexPath(selectedIndexPath) as! TopCollectionViewCell
        let cellFrameInSuperview = cell.thumbNailImageView.convertRect(cell.thumbNailImageView.frame, toView: collectionView?.superview)
        
        let resizedCellFrameInSuperview = CGRectMake(cellFrameInSuperview.origin.x, cellFrameInSuperview.origin.y + PageMenuConstraint.menuHeight, cellFrameInSuperview.size.width, cellFrameInSuperview.size.height)
        
        return resizedCellFrameInSuperview
    }
}
