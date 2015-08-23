//
//  TopCollectionViewController+RPZoomTransitionAnimating.swift
//  Nekobu
//
//  Created by naoyashiga on 2015/08/23.
//  Copyright (c) 2015年 naoyashiga. All rights reserved.
//

import Foundation

extension TopCollectionViewController: RPZoomTransitionAnimating {

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