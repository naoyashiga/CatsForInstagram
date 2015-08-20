//
//  SettingCollectionViewController.swift
//  Nekobu
//
//  Created by naoyashiga on 2015/08/17.
//  Copyright (c) 2015年 naoyashiga. All rights reserved.
//

import UIKit
import Social

struct settingReuseId {
    static let cell = "SettingCollectionViewCell"
    static let headerView = "SettingHeaderView"
}

class SettingCollectionViewController: BaseCollectionViewController {
    let appStoreURL = "http://appstore.com/cats-for-instagram"
    var reviewMenu = [
        "レビューを書いて応援する",
        "他のアプリを見る"
    ]
    var snsMenu = [
        "Twitterでつぶやく",
        "LINEに送る"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.viewBackgroundColor()
        
        collectionView?.backgroundColor = UIColor.viewBackgroundColor()
        
        cellSize.width = view.bounds.width
        cellSize.height = 80
        
        if let collectionView = collectionView {
            collectionView.contentInset = UIEdgeInsetsMake(10, cellMargin.horizontal / 2, 0, cellMargin.horizontal / 2)
        }
        
        collectionView?.applyHeaderNib(headerNibName: settingReuseId.headerView)
        collectionView?.applyCellNib(cellNibName: settingReuseId.cell)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 2
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if section == 0 {
            return reviewMenu.count
        } else {
            return snsMenu.count
        }
    }
    
    override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        
        switch kind {
        case UICollectionElementKindSectionHeader:
            var headerView = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: settingReuseId.headerView, forIndexPath: indexPath) as! SettingHeaderView
            
            switch indexPath.section {
            case 0:
                headerView.titleLabel.text = "応援"
            case 1:
                headerView.titleLabel.text = "アプリを友だちに紹介"
            default:
                break
            }
            
            
            return setCornerRadius(headerView: headerView)
            
        default:
            assert(false, "error")
            return UICollectionReusableView()
        }
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(settingReuseId.cell, forIndexPath: indexPath) as! SettingCollectionViewCell
        
        switch indexPath.section {
        case 0:
            cell.titleLabel.text = reviewMenu[indexPath.row]
        case 1:
            cell.titleLabel.text = snsMenu[indexPath.row]
        default:
            break;
        }
        
        //通常の背景
        let backgroundView = UIView()
        backgroundView.bounds = cell.bounds
        backgroundView.backgroundColor = UIColor.cellLightBackgroundColor()
        cell.backgroundView = backgroundView
        
        //選択時の背景
        let selectedBackgroundView = UIView()
        selectedBackgroundView.bounds = cell.bounds
        selectedBackgroundView.backgroundColor = UIColor.cellSelectedBackgroundColor()
        cell.selectedBackgroundView = selectedBackgroundView
        
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(settingReuseId.cell, forIndexPath: indexPath) as! SettingCollectionViewCell
        
        switch indexPath.section {
        case 0:
            
            if indexPath.row == 0 {
                transitionToReviewPage()
            } else {
                transitionToOtherAppPage()
            }
            
        case 1:
            switch indexPath.row {
            case 0:
                postToTwitter()
            case 1:
                postToLINE()
            default:
                break
            }
            break
        default:
            break
        }
    }
    
    // MARK: UICollectionViewDelegateFlowLayout
    override func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: cellSize.width - cellMargin.horizontal, height: cellSize.height)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: cellSize.width - cellMargin.horizontal, height: 45)
    }
    
    override func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 1.0
    }
    
    override func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 1, left: 0, bottom: 10, right: 0)
    }
    
    func openAppStore(urlStr:String){
        let url = NSURL(string:urlStr)
        let app:UIApplication = UIApplication.sharedApplication()
        app.openURL(url!)
    }
    
    func transitionToOtherAppPage() {
        let otherAppURL = "itms-apps://itunes.apple.com/jp/artist/naoya-sugimoto/id933472785"
        
        openAppStore(otherAppURL)
    }
    func transitionToReviewPage() {
        let APP_ID = "1031396732"
        
        let reviewURL = "itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=" + APP_ID
        
        openAppStore(reviewURL)
    }
    
    func postToTwitter(){
        let vc = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
        let shareText = "iOSアプリ「ねこ部」ねこの写真がたくさん見れるよ! " + appStoreURL
        //テキストを設定
        vc.setInitialText(shareText)
        presentViewController(vc,animated:true,completion:nil)
    }
    
    func postToLINE(){
        let shareText = "iOSアプリ「ねこ部」ねこの写真がたくさん見れるよ! " + appStoreURL
        let encodedText = shareText.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
        
        var shareURL = NSURL(string: "line://msg/text/" + encodedText)
        
        if (UIApplication.sharedApplication().canOpenURL(shareURL!)) {
            UIApplication.sharedApplication().openURL(shareURL!)
        }
    }
}
