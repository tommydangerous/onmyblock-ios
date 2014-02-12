//
//  OMBInformationStepsViewController.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 2/11/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBInformationStepsViewController.h"

#import "OMBCollectionView.h"
#import "OMBInformationStepsCell.h"
#import "OMBInformationStepsFlowLayout.h"
#import "UIColor+Extensions.h"

@implementation OMBInformationStepsViewController

#pragma mark - Initializer

- (id) initWithInformationArray: (NSArray *) array
{
  if (!(self = [super init])) return nil;

  _informationArray = array;

  self.title = @"How it Works";

  return self;
}

#pragma mark - Override

#pragma mark - Override UIViewController

- (void) loadView
{
  [super loadView];

  self.navigationItem.rightBarButtonItem = doneBarButtonItem;

  CGRect screen = [[UIScreen mainScreen] bounds];
  self.view     = [[UIView alloc] initWithFrame: screen];

  CGFloat screenHeight = screen.size.height;
  CGFloat screenWidth  = screen.size.width;
  CGFloat standardHeight = OMBStandardHeight;
  CGFloat padding        = OMBPadding;

  // Layout
  CGSize layoutItemSize = CGSizeMake(screenWidth - (padding * 2),
    (screenHeight - (padding + standardHeight)) - (padding * 6));
  OMBInformationStepsFlowLayout *layout = 
    [[OMBInformationStepsFlowLayout alloc] init];
  layout.itemSize = layoutItemSize;
  layout.headerReferenceSize = CGSizeZero;
  layout.minimumInteritemSpacing = 0.0f;
  layout.minimumLineSpacing = padding * 0.5f;
  layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
  layout.sectionInset = UIEdgeInsetsMake(0.0f, padding * 1, 
    0.0f, padding * 1);
  // Collection view
  pageCollectionView = [[OMBCollectionView alloc] initWithFrame: screen
    collectionViewLayout: layout];
  pageCollectionView.alwaysBounceHorizontal = YES;
  // pageCollectionView.alwaysBounceVertical = YES;
  pageCollectionView.backgroundColor = [UIColor grayUltraLight];
  pageCollectionView.bounces = YES;
  pageCollectionView.dataSource = self;
  pageCollectionView.delegate = self;
  pageCollectionView.showsHorizontalScrollIndicator = NO;
  [self.view addSubview: pageCollectionView];

  scroll = [[UIScrollView alloc] init];
  scroll.frame = CGRectMake(0.0f, 0.0f, 
    layoutItemSize.width,
      pageCollectionView.frame.size.height);
  scroll.delegate = self;
  scroll.hidden = YES;
  scroll.pagingEnabled = YES;
  [self.view addSubview: scroll];

  [pageCollectionView addGestureRecognizer: scroll.panGestureRecognizer];
  pageCollectionView.panGestureRecognizer.enabled = NO;
}

- (void) viewDidLoad
{
  [super viewDidLoad];

  // Do this or else there will be extra spacing at the
  // top of the image collection view
  // self.automaticallyAdjustsScrollViewInsets = NO;

  // Register collection view cell for the collection view
  [pageCollectionView registerClass: [OMBInformationStepsCell class] 
    forCellWithReuseIdentifier: [OMBInformationStepsCell reuseIdentifier]];
}

- (void) viewWillAppear: (BOOL) animated
{
  [super viewWillAppear: animated];

  UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)
    pageCollectionView.collectionViewLayout;
  scroll.contentSize = CGSizeMake(
    layout.itemSize.width * [_informationArray count],
      pageCollectionView.frame.size.height);
}

#pragma mark - Protocol

#pragma mark - Protocol UICollectionViewDataSource

- (UICollectionViewCell *) collectionView: (UICollectionView *) collectionView 
cellForItemAtIndexPath: (NSIndexPath *) indexPath
{
  OMBInformationStepsCell *cell =
    [collectionView dequeueReusableCellWithReuseIdentifier:
      [OMBInformationStepsCell reuseIdentifier] forIndexPath: indexPath];
  NSDictionary *dictionary = [_informationArray objectAtIndex: indexPath.row];
  [cell loadInformation: [dictionary objectForKey: @"information"] 
    title: [dictionary objectForKey: @"title"] step: indexPath.row + 1];
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

#pragma mark - Protocol UIScrollViewDelegate

- (void) scrollViewDidScroll: (UIScrollView *) scrollView
{
  if (scrollView == scroll) {
    // CGPoint contentOffset = scrollView.contentOffset;
    // contentOffset.x = contentOffset.x - pageCollectionView.contentInset.left;
    // pageCollectionView.contentOffset = contentOffset;
    CGPoint contentOffset = scrollView.contentOffset;
    CGPoint pageContentOffset = pageCollectionView.contentOffset;
    CGFloat page = contentOffset.x / scrollView.frame.size.width;
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)
      pageCollectionView.collectionViewLayout;
    pageContentOffset.x = contentOffset.x + (layout.minimumLineSpacing * page);
    pageCollectionView.contentOffset = pageContentOffset;
  }
  else if (scrollView == pageCollectionView) {
    // CGFloat x = scrollView.contentOffset.x;
    // NSLog(@"%f", x);
  }
}

- (void) scrollViewWillEndDragging: (UIScrollView *) scrollView 
withVelocity: (CGPoint) velocity 
targetContentOffset: (inout CGPoint *) targetContentOffset 
{
  // if (scrollView == pageCollectionView) {
  //   UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)
  //     pageCollectionView.collectionViewLayout;
  //   CGFloat width = layout.itemSize.width;

  //   CGFloat x = targetContentOffset->x;
  //   x = roundf(x / width) * width;
  //   targetContentOffset->x = x;

  //   NSLog(@"TARGET: %f", x);
  // } 
}

#pragma mark - Methods

#pragma mark - Instane Methods

- (void) done
{
  [self dismissViewControllerAnimated: YES completion: nil];
}

@end
