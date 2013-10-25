//
//  OMBSpringFlowLayout.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 10/24/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBSpringFlowLayout.h"

@implementation OMBSpringFlowLayout

@synthesize dynamicAnimator      = _dynamicAnimator;
@synthesize interfaceOrientation = _interfaceOrientation;
@synthesize latestDelta          = _latestDelta;
@synthesize visibleIndexPathsSet = _visibleIndexPathsSet;

#pragma mark - Initializer

- (id) init
{
  if (!(self = [super init])) return nil;

  CGRect screen = [[UIScreen mainScreen] bounds];

  // UICollectionViewFlowLayout properties
  self.footerReferenceSize = CGSizeMake(0, 0);
  self.headerReferenceSize = CGSizeMake(0, 0);
  self.itemSize = CGSizeMake(screen.size.width, (screen.size.height * 0.3));
  self.minimumInteritemSpacing = 0;
  self.minimumLineSpacing      = 5;
  self.sectionInset            = UIEdgeInsetsMake(0, 0, -44, 0);

  _dynamicAnimator = [[UIDynamicAnimator alloc] initWithCollectionViewLayout: 
    self];
  _visibleIndexPathsSet = [NSMutableSet set];

  return self;
}

#pragma mark - Override

#pragma mark - Override UICollectionViewLayout

- (NSArray *) layoutAttributesForElementsInRect: (CGRect) rect
{
  // Returns the dynamic items, from the animator’s behaviors, 
  // that intersect a specified rectangle
  return [_dynamicAnimator itemsInRect: rect];
}

- (UICollectionViewLayoutAttributes *) layoutAttributesForItemAtIndexPath:
(NSIndexPath *) indexPath
{
  return [_dynamicAnimator layoutAttributesForCellAtIndexPath: indexPath];
}

- (void) prepareLayout
{
  // Tells the layout object to update the current layout
  // Layout updates occur the first time the collection view presents 
  // its content and whenever the layout is invalidated explicitly 
  // or implicitly because of a change to the view

  // During each layout update, the collection view calls this 
  // method first to give your layout object a chance to 
  // prepare for the upcoming layout operation.
  [super prepareLayout];

  // If the orientation changed, remove all dynamic behaviors
  if ([[UIApplication sharedApplication] statusBarOrientation] 
    != _interfaceOrientation) {

    [_dynamicAnimator removeAllBehaviors];
    _visibleIndexPathsSet = [NSMutableSet set];
  }

  _interfaceOrientation = 
    [[UIApplication sharedApplication] statusBarOrientation];

  // Need to overflow our actual visible rect slightly to avoid flickering
  CGRect visibleRect = CGRectInset(
    (CGRect) {
      .origin = self.collectionView.bounds.origin,
      .size   = self.collectionView.frame.size
    }, -100, -100
  );
  // Items in the visible rect view
  // Returns the layout attributes (UICollectionViewLayoutAttributes) 
  // for all of the cells and views in the specified rectangle
  NSArray *itemsInVisibleRectArray = [super layoutAttributesForElementsInRect:
    visibleRect];
  // A set of index paths for the items in the visible rect
  NSSet *itemsIndexPathsInVisibleRectSet = [NSSet setWithArray: 
    [itemsInVisibleRectArray valueForKey: @"indexPath"]];

  // Step 1: Remove any behaviors that are no longer visible
  NSPredicate *predicate = [NSPredicate predicateWithBlock: 
    ^BOOL (UIAttachmentBehavior *behavior, NSDictionary *bindings) {
      // It is currently visible if the behavior's first item's index path
      // is in the set of visible index paths
      BOOL currentlyVisible = [itemsIndexPathsInVisibleRectSet member:
        [[[behavior items] firstObject] indexPath]] != nil;
      return !currentlyVisible;
    }
  ];
  // Get an array of behaviors that have items which are no longer visible
  NSArray *noLongerVisibleBehaviors = 
    [_dynamicAnimator.behaviors filteredArrayUsingPredicate: predicate];

  void (^enumerateBlock) (id obj, NSUInteger idx, BOOL *stop) =  
    ^ (id obj, NSUInteger idx, BOOL *stop) {
      // Remove the behavior from the dynamic animator
      [_dynamicAnimator removeBehavior: obj];
      // Remove the behavior's first item's index path 
      // from the visible index path set
      [_visibleIndexPathsSet removeObject: 
        [[[obj items] firstObject] indexPath]];
    };
  [noLongerVisibleBehaviors enumerateObjectsUsingBlock: enumerateBlock];

  // Step 2: Add any newly visible behaviors
  predicate = [NSPredicate predicateWithBlock: 
    ^BOOL (UICollectionViewLayoutAttributes *item, NSDictionary *bindings) {
      // A newly visible item is one that is in the 
      // itemsInVisibleRect(Set|Array) but not in the visibleIndexPathSet
      BOOL currentlyVisible = [_visibleIndexPathsSet member: 
        item.indexPath] != nil;
      return !currentlyVisible;
    }
  ];
  NSArray *newlyVisibleItems = 
    [itemsInVisibleRectArray filteredArrayUsingPredicate: predicate];

  // Get the point where the user touches before dragging
  CGPoint touchLocation = 
    [self.collectionView.panGestureRecognizer locationInView: 
      self.collectionView];

  // Do this block to each of the newly visible items
  [newlyVisibleItems enumerateObjectsUsingBlock: 
    ^ (UICollectionViewLayoutAttributes *item, NSUInteger idx, BOOL *stop) {
      // Center point of the item
      CGPoint center = item.center;
      UIAttachmentBehavior *springBehavior = 
        [[UIAttachmentBehavior alloc] initWithItem: item 
          attachedToAnchor: center];
      springBehavior.damping   = 0.8f;
      springBehavior.length    = 1.0f;
      springBehavior.frequency = 1.0f;
      // If our touch location is not (0, 0), 
      // we will need to adjust our item's center "in flight"
      if (!CGPointEqualToPoint(CGPointZero, touchLocation)) {
        CGFloat distanceFromTouch = fabsf(
          touchLocation.y - springBehavior.anchorPoint.y);
        CGFloat scrollResistance = distanceFromTouch / 1500.0f;
        if (_latestDelta < 0)
          center.y += MAX(_latestDelta, _latestDelta * scrollResistance);
        else
          center.y += MIN(_latestDelta, _latestDelta * scrollResistance);
        item.center = center;
      }
      // Add spring behavior to the dynamic animator
      [_dynamicAnimator addBehavior: springBehavior];
      // Add the item's index path to the visible index path set
      [_visibleIndexPathsSet addObject: item.indexPath];
    }
  ];
}

- (BOOL) shouldInvalidateLayoutForBoundsChange: (CGRect) newBounds
{
  // Asks the layout object if the new bounds require a layout update
  UIScrollView *scrollView = self.collectionView;
  CGFloat delta = newBounds.origin.y - scrollView.bounds.origin.y;
  _latestDelta = delta;
  CGPoint touchLocation = 
    [self.collectionView.panGestureRecognizer locationInView: 
      self.collectionView];
  // Update each behavior
  [_dynamicAnimator.behaviors enumerateObjectsUsingBlock: 
    ^(UIAttachmentBehavior *springBehavior, NSUInteger idx, BOOL *stop) {
      CGFloat distanceFromTouch = fabsf(
        touchLocation.y - springBehavior.anchorPoint.y);
      CGFloat scrollResistance = distanceFromTouch / 1500.f;
      UICollectionViewLayoutAttributes *item = 
        [springBehavior.items firstObject];
      CGPoint center = item.center;
      if (delta < 0)
        center.y += MAX(delta, delta * scrollResistance);
      else
        center.y += MIN(delta, delta * scrollResistance);
      item.center = center;
      [_dynamicAnimator updateItemUsingCurrentState: item];
    }
  ];
  return NO;
}

@end
