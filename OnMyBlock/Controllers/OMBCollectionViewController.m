//
//  OMBCollectionViewController.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 10/24/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBCollectionViewController.h"

#import "OMBResidenceCollectionViewCell.h"
#import "OMBSpringFlowLayout.h"

@implementation OMBCollectionViewController

static NSString * CellIdentifier = @"CellIdentifier";

@synthesize collectionView       = _collectionView;
@synthesize collectionViewLayout = _collectionViewLayout;

- (void) loadView
{
  CGRect screen = [[UIScreen mainScreen] bounds];

  _collectionViewLayout = [[OMBSpringFlowLayout alloc] init];
  _collectionView = [[UICollectionView alloc] initWithFrame: screen
    collectionViewLayout: _collectionViewLayout];
  _collectionView.dataSource = self;
  _collectionView.delegate   = self;
  self.view = _collectionView;
}

- (void) viewDidLoad 
{
  [super viewDidLoad];
    
  [_collectionView registerClass: [OMBResidenceCollectionViewCell class] 
    forCellWithReuseIdentifier: CellIdentifier];
  _collectionView.backgroundColor = [UIColor blueColor];
}

#pragma mark - Protocol

#pragma mark - Protocol UICollectionViewDataSource

- (UICollectionViewCell *) collectionView: (UICollectionView *) collectionView 
cellForItemAtIndexPath: (NSIndexPath *) indexPath 
{
  UICollectionViewCell *cell = 
    [collectionView dequeueReusableCellWithReuseIdentifier: CellIdentifier 
      forIndexPath: indexPath];

  CGRect screen = [[UIScreen mainScreen] bounds];

  cell.backgroundColor = [UIColor redColor];

  UIView *mainView = [[UIView alloc] init];
  mainView.backgroundColor = [UIColor blueColor];
  mainView.frame = CGRectMake(0, 0, screen.size.width, 40);
  [cell.contentView addSubview: mainView];

  return cell;
}


- (NSInteger) collectionView: (UICollectionView *) collectionView 
numberOfItemsInSection: (NSInteger) section 
{
  return 100;
}

#pragma mark - Protocol UICollectionViewDelegate

@end
