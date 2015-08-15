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
        photoDetailVC.transitioningDelegate = self
        photoDetailVC.detailImageURL = media.standardImageURL
        
        presentViewController(photoDetailVC, animated: true, completion: {
            
        })
    }

    // MARK: UIViewControllerTransitioningDelegate
    func presentationControllerForPresentedViewController(presented: UIViewController, presentingViewController presenting: UIViewController!, sourceViewController source: UIViewController) -> UIPresentationController? {
        return BlurredBackgroundPresentationController(presentedViewController: presented, presentingViewController: presenting)
    }
}

extension UIImageView {
    func loadingImageBySDWebImage(media: Media) {
        
        sd_setImageWithURL(
            media.thumbNailURL,
            completed: { image, error, type, URL in
                
                self.alpha = 0
                
                UIView.animateWithDuration(0.25,
                    animations: {
                        self.alpha = 1
                })
        })
    }
}
// MARK: Alamofire_SwiftyJSON
extension Request {
    
    /**
    Adds a handler to be called once the request has finished.
    
    :param: completionHandler A closure to be executed once the request has finished. The closure takes 4 arguments: the URL request, the URL response, if one was received, the SwiftyJSON enum, if one could be created from the URL response and data, and any error produced while creating the SwiftyJSON enum.
    
    :returns: The request.
    */
    public func responseSwiftyJSON(completionHandler: (NSURLRequest, NSHTTPURLResponse?, SwiftyJSON.JSON, NSError?) -> Void) -> Self {
        return responseSwiftyJSON(queue:nil, options:NSJSONReadingOptions.AllowFragments, completionHandler:completionHandler)
    }
    
    /**
    Adds a handler to be called once the request has finished.
    
    :param: queue The queue on which the completion handler is dispatched.
    :param: options The JSON serialization reading options. `.AllowFragments` by default.
    :param: completionHandler A closure to be executed once the request has finished. The closure takes 4 arguments: the URL request, the URL response, if one was received, the SwiftyJSON enum, if one could be created from the URL response and data, and any error produced while creating the SwiftyJSON enum.
    
    :returns: The request.
    */
    public func responseSwiftyJSON(queue: dispatch_queue_t? = nil, options: NSJSONReadingOptions = .AllowFragments, completionHandler: (NSURLRequest, NSHTTPURLResponse?, JSON, NSError?) -> Void) -> Self {
        
        return response(queue: queue, responseSerializer: Request.JSONResponseSerializer(options: options), completionHandler: { (request, response, object, error) -> Void in
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
                
                var responseJSON: JSON
                if error != nil || object == nil{
                    responseJSON = JSON.nullJSON
                } else {
                    responseJSON = SwiftyJSON.JSON(object!)
                }
                
                dispatch_async(queue ?? dispatch_get_main_queue(), {
                    completionHandler(self.request, self.response, responseJSON, error)
                })
            })
        })
    }
}