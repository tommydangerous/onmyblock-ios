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

  UIPanGestureRecognizer *panRecognizer = 
    [[UIPanGestureRecognizer alloc] initWithTarget: self 
      action: @selector(panDetected:)];
  panRecognizer.delegate = self;
  [self.view addGestureRecognizer:panRecognizer];

  _animator = [[UIDynamicAnimator alloc] initWithReferenceView: self.view];
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
  cell.indexPath = indexPath;
  [cell initGestures];
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

- (void) panDetected: (UIPanGestureRecognizer *) gestureRecognizer
{
  CGPoint point = [gestureRecognizer locationInView: self.view];

  CGFloat currentY = point.y;
  CGFloat verticalDifference = currentY - lastPoint.y;

  CGFloat translationY = 0.0f;

  NSInteger index = scroll.contentOffset.x / scroll.frame.size.width;

  OMBInformationStepsCell *cell = (OMBInformationStepsCell *)
    [pageCollectionView cellForItemAtIndexPath: 
      [NSIndexPath indexPathForRow: index inSection: 0]];

  if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
    lastPoint = point;

    // [_animator removeBehavior: _elasticityBehavior];
    // [_animator removeBehavior: _gravityBehavior];
    // [_animator removeBehavior: _snapBehavior];
  }
  else if (gestureRecognizer.state == UIGestureRecognizerStateChanged) {
    if (fabs(verticalDifference) > 0) {
      translationY = verticalDifference;
    }

    if (verticalDifference != 0) {
      // pageCollectionView.transform = CGAffineTransformTranslate(
      //   CGAffineTransformIdentity, 0, translationY);
      // CGRect rect = pageCollectionView.frame;
      // rect.origin.y += verticalDifference;
      // pageCollectionView.frame = rect;
      // NSLog(@"%f", verticalDifference);
      // verticalDifference = 0.0f;



      CGPoint translation = [gestureRecognizer translationInView: self.view];
      
      // CGRect rect = cell.frame;
      // rect.origin.y += translation.y;
      // cell.frame = rect;

      cell.transform = CGAffineTransformTranslate(cell.transform,
        0.0f, translation.y);

      [gestureRecognizer setTranslation: CGPointZero inView: self.view];
    }
  }
  else if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
    // NSLog(@"SNAP BACK");
    
    // _gravityBehavior = 
    //   [[UIGravityBehavior alloc] initWithItems: @[cell]];
    // _gravityBehavior.gravityDirection = CGVectorMake(0, 10);
    // [_animator addBehavior: _gravityBehavior];

    // // Snap the button in the middle
    // CGPoint center = CGPointMake(cell.center.x, 
    //   (OMBPadding * 1.0f) + self.view.center.y);
    // _snapBehavior = [[UISnapBehavior alloc] initWithItem: cell 
    //   snapToPoint: center];
    // // We decrease the damping so the view has a little less spring.
    // _snapBehavior.action = ^{
    //   cell.transform = CGAffineTransformIdentity;
    // };
    // _snapBehavior.damping = 1.0f;
    // // Add animator
    // [_animator addBehavior: _snapBehavior];

    // // More bouncing
    // _elasticityBehavior = [[UIDynamicItemBehavior alloc] initWithItems: 
    //   @[cell]];
    // // _elasticityBehavior.allowsRotation = NO;
    // // _elasticityBehavior.elasticity = 0.0f;
    // // [_animator addBehavior: _elasticityBehavior];
    // // cell.transform = CGAffineTransformIdentity;

    [UIView animateWithDuration: OMBStandardDuration * 2 delay: 0.0
      usingSpringWithDamping: 0.65 initialSpringVelocity: 0.5 options: 0
        animations: ^{
          cell.transform = CGAffineTransformIdentity;
        }
        completion: nil];
  }
}

@end
