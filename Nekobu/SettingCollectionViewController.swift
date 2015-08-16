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
}

class SettingCollectionViewController: BaseCollectionViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cellSize.width = view.bounds.width
        cellSize.height = 80
        
        collectionView?.applyCellNib(cellNibName: settingReuseId.cell)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(settingReuseId.cell, forIndexPath: indexPath) as! SettingCollectionViewCell
        
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(settingReuseId.cell, forIndexPath: indexPath) as! SettingCollectionViewCell
    }
}
