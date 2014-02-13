//
//  OMBCollectionViewController.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 10/24/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBViewController.h"

#import "OMBCollectionView.h"
#import "OMBCollectionViewFlowLayout.h"

@interface OMBCollectionViewController : OMBViewController
<UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) OMBCollectionView *collectionView;
@property (nonatomic, strong) 
  OMBCollectionViewFlowLayout *collectionViewFlowLayout;

@end
