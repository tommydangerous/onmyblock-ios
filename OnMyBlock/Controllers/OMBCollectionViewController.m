//
//  OMBCollectionViewController.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 10/24/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBCollectionViewController.h"

@implementation OMBCollectionViewController

- (void) loadView
{
  CGRect screen = [[UIScreen mainScreen] bounds];

  self.view = [[UIView alloc] initWithFrame: screen];

  _collectionViewFlowLayout = [[OMBCollectionViewFlowLayout alloc] init];
  _collectionView = [[OMBCollectionView alloc] initWithFrame: screen
    collectionViewLayout: _collectionViewFlowLayout];
  _collectionView.dataSource = self;
  _collectionView.delegate   = self;
  [self.view addSubview: _collectionView];
}

#pragma mark - Protocol

#pragma mark - Protocol UICollectionViewDataSource

- (UICollectionViewCell *) collectionView: (UICollectionView *) collectionView 
cellForItemAtIndexPath: (NSIndexPath *) indexPath 
{
  UICollectionViewCell *cell = 
    [collectionView dequeueReusableCellWithReuseIdentifier: 
      @"UICollectionViewCellReuseIdentifier" forIndexPath: indexPath];
  return cell;
}

- (NSInteger) collectionView: (UICollectionView *) collectionView 
numberOfItemsInSection: (NSInteger) section 
{
  return 0;
}

- (NSInteger) numberOfSectionsInCollectionView: 
(UICollectionView *) collectionView
{
  return 1;
}

#pragma mark - Protocol UICollectionViewDelegate

- (void) collectionView: (UICollectionView *) collectionView 
didSelectItemAtIndexPath: (NSIndexPath *) indexPath
{
  // Subclasses implement this
}

#pragma mark - Protocol UICollectionViewDelegateFlowLayout

- (CGSize) collectionView: (UICollectionView *) collectionView 
layout: (UICollectionViewLayout *) collectionViewLayout 
referenceSizeForFooterInSection: (NSInteger) section
{
  return CGSizeZero;
}

- (UIEdgeInsets) collectionView: (UICollectionView *) collectionView 
layout: (UICollectionViewLayout*) collectionViewLayout 
insetForSectionAtIndex: (NSInteger) section
{
  return UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f);
}

- (CGFloat) collectionView: (UICollectionView *) collectionView 
layout: (UICollectionViewLayout*) collectionViewLayout 
minimumInteritemSpacingForSectionAtIndex: (NSInteger) section
{
  return 0.0f;
}

- (CGFloat) collectionView: (UICollectionView *) collectionView 
layout: (UICollectionViewLayout*) collectionViewLayout 
minimumLineSpacingForSectionAtIndex: (NSInteger) section
{
  return 0.0f;
}

- (CGSize) collectionView: (UICollectionView * ) collectionView 
layout: (UICollectionViewLayout*) collectionViewLayout 
sizeForItemAtIndexPath: (NSIndexPath *) indexPath
{
  return CGSizeZero;
}

@end
