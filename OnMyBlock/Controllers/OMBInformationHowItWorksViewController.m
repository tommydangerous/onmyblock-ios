//
//  OMBInformationHowItWorksViewController.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 2/13/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBInformationHowItWorksViewController.h"

#import "NSString+Extensions.h"
#import "OMBInformationHowItWorksCell.h"

@implementation OMBInformationHowItWorksViewController

#pragma mark - Initializer

- (id) initWithInformationArray: (NSArray *) array
{
  if (!(self = [super init])) return nil;

  fontForInformationText = [UIFont mediumTextFont];
  informationSizeArray = [NSMutableArray array];
  // Each dictionary in the array has a title and information key
  _informationArray = array;

  self.title = @"How it Works";

  return self;
}

#pragma mark - Override

#pragma mark - Override UIViewController

- (void) loadView
{
  [super loadView];

  self.collectionView.backgroundColor = [UIColor grayUltraLight];
  self.collectionView.showsVerticalScrollIndicator = NO;
}

- (void) viewDidLoad
{
  [super viewDidLoad];

  [self.collectionView registerClass: [OMBInformationHowItWorksCell class]
    forCellWithReuseIdentifier: [OMBInformationHowItWorksCell reuseIdentifier]];
}

- (void) viewWillAppear: (BOOL) animated
{
  [super viewWillAppear: animated];
  
  for (NSDictionary *dictionary in _informationArray) {
    CGSize size = 
      [[dictionary objectForKey: @"information"] boundingRectWithSize: 
        CGSizeMake(
          self.collectionView.frame.size.width - (OMBPadding * 2), 9999) 
            font: fontForInformationText].size;
    [informationSizeArray addObject: [NSValue valueWithCGSize: size]];
  }
  [self.collectionView reloadData];
}

#pragma mark - Protocol

#pragma mark - Protocol UICollectionViewDataSource

- (UICollectionViewCell *) collectionView: (UICollectionView *) collectionView 
cellForItemAtIndexPath: (NSIndexPath *) indexPath 
{
  OMBInformationHowItWorksCell *cell = 
    [collectionView dequeueReusableCellWithReuseIdentifier: 
      [OMBInformationHowItWorksCell reuseIdentifier] forIndexPath: indexPath];
  [cell loadInformation: [_informationArray objectAtIndex: indexPath.row] 
    atIndexPath: indexPath size: [[informationSizeArray objectAtIndex: 
      indexPath.row] CGSizeValue]];
  return cell;
}

- (NSInteger) collectionView: (UICollectionView *) collectionView 
numberOfItemsInSection: (NSInteger) section 
{
  return [_informationArray count];
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
  // Nothing
}

#pragma mark - Protocol UICollectionViewDelegateFlowLayout

- (UIEdgeInsets) collectionView: (UICollectionView *) collectionView 
layout: (UICollectionViewLayout*) collectionViewLayout 
insetForSectionAtIndex: (NSInteger) section
{
  return UIEdgeInsetsMake(OMBPadding, OMBPadding, OMBPadding, OMBPadding);
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
  return OMBPadding;
}

- (CGSize) collectionView: (UICollectionView * ) collectionView 
layout: (UICollectionViewLayout*) collectionViewLayout 
sizeForItemAtIndexPath: (NSIndexPath *) indexPath
{
  CGFloat height = [[informationSizeArray objectAtIndex: 
    indexPath.row] CGSizeValue].height;
  CGFloat width = collectionView.frame.size.width - (OMBPadding * 2);
  return CGSizeMake(width, 
    [OMBInformationHowItWorksCell heightForTitleLabel] + height);
}

@end
