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
    
    var detailImageURL: NSURL?
    var media = Media()
    
    var savingImageView = UIImageView()
    
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
            println("お気に入り未登録")
            favoriteButton.selected = false
        } else {
            //お気に入り登録済み
            println("お気に入り登録済み")
            favoriteButton.selected = true
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func favoriteButtonTapped(sender: UIButton) {
        
        let realm = Realm()
        
        let predicate = NSPredicate(format: "id == %@", media.id)
        let exisitingFavoriteArray = realm.objects(Favorite).filter(predicate)
        
        if favoriteButton.selected {
            //お気に入り削除
            if exisitingFavoriteArray.count != 0 {
                
                realm.write {
                    println("remove fav")
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
                
                favorite.lowResolutionBase64ImageString = media.lowResolutionBase64ImageString
                favorite.standardResolutionBase64ImageString = media.standardResolutionBase64ImageString
                
                favorite.createdAt = NSDate().timeIntervalSince1970
                
                realm.write {
                    println("add fav")
                    realm.add(favorite, update: true)
                    
                    self.favoriteButton.selected = true
                }
            }
        }
        
        favoriteButton.playBounceAnimation()
    }
    
    @IBAction func shareButtonTapped(sender: UIButton) {
        
        var sharedText = "#ねこ部 のネコかわいい!"
        
        var sharedURL = NSURL(string: "instagram://media?id=\(media.id)")!
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
            UIActivityTypePostToWeibo,
            UIActivityTypePrint
        ]
        
        activityVC.excludedActivityTypes = excludedActivityTypes
        
        presentViewController(activityVC, animated: true, completion: nil)
    }
    
    @IBAction func saveImageButtonTapped(sender: UIButton) {
        
        //高画質画像を読み込み、保存
        savingImageView.sd_setImageWithURL(
            media.standardResolutionImageURL,
            completed: { savingImage, error, type, URL in
                
                if error == nil {
                    UIImageWriteToSavedPhotosAlbum(savingImage, self, "image:didFinishSavingWithError:contextInfo:", nil)
                    
                } else {
                    println("保存したい画像を取得できませんでした")
                    
                }
        })
        
//        if let savingImage = detailImageView.image {
//            UIImageWriteToSavedPhotosAlbum(savingImage, self, "image:didFinishSavingWithError:contextInfo:", nil)
//        } else {
//            println("保存したい画像を取得できませんでした")
//        }
    }
    
    @IBAction func dismissButtonTapped(sender: UIButton) {
        dismissButton.playBounceAnimation()
        presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func image(image: UIImage, didFinishSavingWithError error: NSError!, contextInfo: UnsafeMutablePointer<Void>) {
        var title = "保存完了"
        var message = "カメラロールに保存できました"
        
        if error != nil {
            title = "エラー"
            message = "カメラロールへの保存に失敗しました"
            println(error.code)
        }
        
        let alert = UIAlertView(title: title, message: message, delegate: nil, cancelButtonTitle: nil, otherButtonTitles: "OK")
        alert.show()
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
}
