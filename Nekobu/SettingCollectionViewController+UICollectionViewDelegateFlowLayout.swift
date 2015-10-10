//
//  SettingCollectionViewController+UICollectionViewDelegateFlowLayout.swift
//  Nekobu
//
//  Created by naoyashiga on 2015/08/23.
//  Copyright (c) 2015年 naoyashiga. All rights reserved.
//

import UIKit

extension SettingCollectionViewController {

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
}