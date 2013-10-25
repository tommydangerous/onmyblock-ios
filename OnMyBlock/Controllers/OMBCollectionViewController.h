//
//  OMBCollectionViewController.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 10/24/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBViewController.h"

@interface OMBCollectionViewController : OMBViewController
<UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewLayout *collectionViewLayout;

@end
