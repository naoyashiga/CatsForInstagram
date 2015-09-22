//
//  PhotoDetailViewController.swift
//  Nekobu
//
//  Created by naoyashiga on 2015/08/15.
//  Copyright (c) 2015年 naoyashiga. All rights reserved.
//

import UIKit
import RealmSwift
import WebImage

class PhotoDetailViewController: UIViewController, RPZoomTransitionAnimating {
    @IBOutlet var detailImageView: UIImageView! {
        didSet {
//            detailImageView.image = media.standardResolutionBase64ImageString.String2Image()
//            detailImageView.image = media.lowResolutionBase64ImageString.String2Image()
            
            SDWebImageManager.sharedManager().imageCache.queryDiskCacheForKey(media.lowResolutionImageURL?.absoluteString
                , done: { (image: UIImage!, type: SDImageCacheType) -> Void in
                    
                    self.detailImageView.image = image
            })
        }
    }
    @IBOutlet var favoriteButton: UIButton!
    @IBOutlet var dismissButton: UIButton!
    
//    var detailImageURL: NSURL?
    var media = Media()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.layer.cornerRadius = 10.0
        view.clipsToBounds = true
        
//        detailImageView.sd_setImageWithURL(
//            detailImageURL,
//            completed: { image, error, type, URL in
//                self.media.standardResolutionBase64ImageString = image.Image2String()
//        })
        
        let realm = Realm()
        let predicate = NSPredicate(format: "id == %@", media.id)
        
        if realm.objects(Favorite).filter(predicate).count == 0 {
            //お気に入り未登録
            favoriteButton.selected = false
        } else {
            //お気に入り登録済み
            favoriteButton.selected = true
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(animated: Bool) {
    }

    @IBAction func favoriteButtonTapped(sender: UIButton) {
        updateFavorite()
    }
    
    @IBAction func shareButtonTapped(sender: UIButton) {
        postToSNS(id: media.id, webPageLinkString: media.webPageLinkString)
    }
    
    @IBAction func saveImageButtonTapped(sender: UIButton) {
        saveImageToCameraRoll()
    }
    
    @IBAction func dismissButtonTapped(sender: UIButton) {
        dismissButton.playBounceAnimation()
        presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func postToSNS(id id: String, webPageLinkString: String) {
        let sharedText = NSLocalizedString("shareText", tableName: "Detail", comment: "")
        
        let sharedURL = NSURL(string: webPageLinkString)!
//        var sharedURL = NSURL(string: "instagram://media?id=\(id)")!
        var activityItems = [AnyObject]()
        
        if let sharedImage = detailImageView.image {
            activityItems = [sharedText,sharedURL,sharedImage]
        } else {
            activityItems = [sharedText,sharedURL]
        }
        
        let LineKit = LINEActivity()
        let myApplicationActivities = [LineKit]
        
        let activityVC = UIActivityViewController(activityItems: activityItems, applicationActivities: myApplicationActivities)
        
        let excludedActivityTypes = [
            UIActivityTypeMessage,
            UIActivityTypeMail,
            UIActivityTypeAssignToContact,
            UIActivityTypeAddToReadingList,
            UIActivityTypePostToFlickr,
            UIActivityTypePostToVimeo,
            UIActivityTypePostToTencentWeibo,
            UIActivityTypePostToWeibo,
            UIActivityTypePrint
        ]
        
        activityVC.excludedActivityTypes = excludedActivityTypes
        
        presentViewController(activityVC, animated: true, completion: nil)
        
    }
    
    func saveImageToCameraRoll() {
        let savingImageView = UIImageView()
        
        //高画質画像を読み込み、保存
        savingImageView.sd_setImageWithURL(
            media.standardResolutionImageURL,
            completed: { savingImage, error, type, URL in
                
                if error == nil {
                    UIImageWriteToSavedPhotosAlbum(savingImage, self, "image:didFinishSavingWithError:contextInfo:", nil)
                    
                } else {
                    print("保存したい画像を取得できませんでした")
                    
                }
        })
    }
    
    func updateFavorite() {
        let realm = Realm()
        
        let predicate = NSPredicate(format: "id == %@", media.id)
        let exisitingFavoriteArray = realm.objects(Favorite).filter(predicate)
        
        if favoriteButton.selected {
            //お気に入り削除
            if exisitingFavoriteArray.count != 0 {
                
                realm.write {
                    realm.delete(exisitingFavoriteArray[0])
                    
                    self.favoriteButton.selected = false
                }
            }
            
        } else {
            //お気に入り追加
            if exisitingFavoriteArray.count == 0 {
                
//                SDWebImageManager.sharedManager().imageCache.storeImage(media.standardResolutionBase64ImageString.String2Image(), forKey: String(media.id))
                
                let favorite = Favorite()
                favorite.id = media.id
                //高画質版のURLを保存したい
                
//                if let lowResolutionImageURL = media.lowResolutionImageURL {
//                    favorite.lowResolutionImageURLString = lowResolutionImageURL.absoluteString!
//                SDWebImageManager.sharedManager().imageCache.storeImage(media.standardResolutionBase64ImageString.String2Image(), forKey: favorite.lowResolutionImageURLString)
//                }
                
                if let standardResolutionImageURL = media.standardResolutionImageURL {
                    favorite.standardResolutionURLString = standardResolutionImageURL.absoluteString
                }
                
                favorite.lowResolutionBase64ImageString = media.lowResolutionBase64ImageString
                favorite.standardResolutionBase64ImageString = media.standardResolutionBase64ImageString
                favorite.webPageLinkString = media.webPageLinkString
                
                favorite.createdAt = NSDate().timeIntervalSince1970
                
                realm.write {
                    realm.add(favorite, update: true)
                    
                    self.favoriteButton.selected = true
                }
            }
        }
        
        favoriteButton.playBounceAnimation()
        
    }
    
    func image(image: UIImage, didFinishSavingWithError error: NSError!, contextInfo: UnsafeMutablePointer<Void>) {
        var title = NSLocalizedString("saveToCameraRollTitle", tableName: "Detail", comment: "")
        var message = NSLocalizedString("saveToCameraRollMessage", tableName: "Detail", comment: "")
        
        if error != nil {
            title = NSLocalizedString("saveToCameraRollErrorTitle", tableName: "Detail", comment: "")
            message = NSLocalizedString("saveToCameraRollErrorMessage", tableName: "Detail", comment: "")
            print(error.code)
        }
        
        let ac = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        
        let okAction = UIAlertAction(title: "OK", style: .Default) { (action) -> Void in
        }
        
        ac.addAction(okAction)
        
        presentViewController(ac, animated: true, completion: nil)
    }
    
    // MARK: RPZoomTransitionAnimating
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
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
