//
//  SettingCollectionViewController.swift
//  Nekobu
//
//  Created by naoyashiga on 2015/08/17.
//  Copyright (c) 2015年 naoyashiga. All rights reserved.
//

import UIKit

struct settingReuseId {
    static let cell = "SettingCollectionViewCell"
    static let headerView = "SettingHeaderView"
}

class SettingCollectionViewController: BaseCollectionViewController {
    var reviewMenu = [
        "レビューを書いて応援する",
        "他のアプリを見る"
    ]
    var snsMenu = [
        "Twitter",
        "Facebook",
        "LINE"
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
}
