//
//  OMBInformationStepsViewController.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 2/11/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBTableViewController.h"

@interface OMBInformationStepsViewController : OMBTableViewController
<UICollectionViewDataSource, UICollectionViewDelegate, UIScrollViewDelegate>
{
  UICollectionView *pageCollectionView;
  UIScrollView *scroll;
}

#pragma mark - Initializer

- (id) initWithInformationArray: (NSArray *) array;

@property (nonatomic, strong) NSArray *informationArray;

@end
