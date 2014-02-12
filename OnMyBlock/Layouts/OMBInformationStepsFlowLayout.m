//
//  OMBInformationStepsFlowLayout.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 2/11/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBInformationStepsFlowLayout.h"

CGFloat kInformationStepsScrollResistance = 1500.0f;

@implementation OMBInformationStepsFlowLayout

#pragma mark - Initializer

- (id) init
{
  if (!(self = [super init])) return nil;

  // CGRect screen = [[UIScreen mainScreen] bounds];

  // UICollectionViewFlowLayout properties

  // If the delegate does not implement the 
  // collectionView:layout:sizeForItemAtIndexPath: method, 
  // the flow layout uses the value in this property to set the size of each 
  // cell. This results in cells that all have the same size.
  // self.itemSize = CGSizeMake(300.0f, 44.0f);

  // The minimum spacing to use between items in the same row
  // self.minimumInteritemSpacing = 10.0f;

  // The minimum spacing to use between lines of items in the grid
  // self.minimumLineSpacing      = 10.0f;

  // The margins used to lay out content in a section
  // self.sectionInset = UIEdgeInsetsMake(30.0f, 10.0f, 10.0f, 10.0f);

  // The behaviors (and their dynamic items) that you add to the animator 
  // employ the collection view layout’s coordinate system
  _dynamicAnimator = [[UIDynamicAnimator alloc] initWithCollectionViewLayout:
    self];

  _visibleIndexPathsSet = [NSMutableSet set];

  return self;
}

#pragma mark - Override

#pragma mark - Override UICollectionViewLayout

- (NSArray *) layoutAttributesForElementsInRect: (CGRect) rect
{
  // Returns the layout attributes for all of the cells and 
  // views in the specified rectangle

  // Returns the dynamic items, from the animator's behaviors,
  // that intersect a specified rectangle
  return [_dynamicAnimator itemsInRect: rect];
}

- (UICollectionViewLayoutAttributes *) layoutAttributesForItemAtIndexPath:
(NSIndexPath *) indexPath
{
  // Returns the layout attributes for the item at the specified index path

  // The collection view layout attributes for 
  // the specified collection view cell
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

  // Layout attributes in the visible rectangle view
  // Returns the layout attributes (UICollectionViewLayoutAttributes)
  // for all of the cells and views in the specified rectangle
  NSArray *attributesForItemsInVisibleRectArray = 
    [super layoutAttributesForElementsInRect: visibleRect];
  // A set of index paths for layout attributes in the visible rectangle
  // Each UICollectionViewLayoutAttributes object has a property indexPath
  NSSet *indexPathsForItemsInVisibleRectSet = [NSSet setWithArray:
    [attributesForItemsInVisibleRectArray valueForKey: @"indexPath"]];

  // STEP 1
  // Remove any behaviors that are no longer in the visible rectangle
  NSPredicate *predicateNotVisibleBehaviors = [NSPredicate predicateWithBlock:
    ^BOOL (UIAttachmentBehavior *attachmentBehavior, NSDictionary *bindings) {
      // If the attachment behavior's first item's index path is
      // in indexPathsForItemsInVisibleRectSet, it is visible
      NSArray *attachmentBehaviorItems = attachmentBehavior.items;
      UICollectionViewLayoutAttributes *attribute = 
        [attachmentBehaviorItems firstObject];
      BOOL currentlyVisible = [indexPathsForItemsInVisibleRectSet member:
        attribute.indexPath] != nil;
      // If the item is currently visible, then do not include it in the
      // filtered array (noLongerVisibleBehaviors)
      return !currentlyVisible;
    }
  ];
  // Get an array of behaviors that have items which are no longer visible
  NSArray *noLongerVisibleBehaviors = 
    [_dynamicAnimator.behaviors filteredArrayUsingPredicate:
      predicateNotVisibleBehaviors];
  // Remove non-visible behaviors from the dynamic animator
  // and remove its first item's index path from the visible indexPath set
  // (_visibleIndexPathsSet)
  void (^removeBehaviorAndIndexPathBlock) 
    (UIAttachmentBehavior *attachmentBehavior, NSUInteger idx, BOOL *stop) =
    ^(UIAttachmentBehavior *attachmentBehavior, NSUInteger idx, BOOL *stop) {
      // Remove the behavior from the dynamic animator
      [_dynamicAnimator removeBehavior: attachmentBehavior];
      // Remove the behavior's first item's indexPath
      // from the visible indexPath set (_visibleIndexPathsSet)
      NSArray *attachmentBehaviorItems = attachmentBehavior.items;
      UICollectionViewLayoutAttributes *attribute = 
        [attachmentBehaviorItems firstObject];
      [_visibleIndexPathsSet removeObject: attribute.indexPath];
    };
  [noLongerVisibleBehaviors enumerateObjectsUsingBlock: 
    removeBehaviorAndIndexPathBlock];

  // STEP 2
  // Add any newly visible behaviors
  NSPredicate *predicateNewlyVisibleAttributes = 
    [NSPredicate predicateWithBlock: 
    ^BOOL (UICollectionViewLayoutAttributes *attribute, 
    NSDictionary *bindings) {
      // A newly visible layout attribute item is one that is in the
      // attributesForItemsInVisibleRectArray but not in the 
      // _visibleIndexPathsSet
      BOOL currentlyVisible = [_visibleIndexPathsSet member:
        attribute.indexPath] != nil;
      return !currentlyVisible;
    }
  ];
  // Out of all the layout attributes in attributesForItemsInVisibleRectArray
  // only get the layout attributes that are newly visible
  NSArray *newlyVisibleAttributes = 
    [attributesForItemsInVisibleRectArray filteredArrayUsingPredicate: 
      predicateNewlyVisibleAttributes];

  // Get the point where the user touches before dragging
  CGPoint touchLocation =
    [self.collectionView.panGestureRecognizer locationInView:
      self.collectionView];

  [newlyVisibleAttributes enumerateObjectsUsingBlock:
    ^(UICollectionViewLayoutAttributes *attribute, NSUInteger idx, BOOL *stop) {
      // Center point of the attribute
      CGPoint center = attribute.center;
      // Initializes an attachment behavior that connects the center point 
      // of a dynamic item to an anchor point
      UIAttachmentBehavior *attachmentBehavior = 
        [[UIAttachmentBehavior alloc] initWithItem: attribute
          attachedToAnchor: center];
      attachmentBehavior.damping   = 0.8f;
      attachmentBehavior.frequency = 1.0f;
      attachmentBehavior.length    = 1.0f;
      // If our touch location is not (0, 0),
      // we will need to adjust our item's center "in flight"
      if (!CGPointEqualToPoint(CGPointZero, touchLocation)) {
        CGFloat distanceFromTouch = fabsf(
          touchLocation.y - attachmentBehavior.anchorPoint.y);
        CGFloat scrollResistance = distanceFromTouch /
          kInformationStepsScrollResistance;
        if (_latestDelta < 0)
          center.y += MAX(_latestDelta, _latestDelta * scrollResistance);
        else
          center.y += MIN(_latestDelta, _latestDelta * scrollResistance);
        attribute.center = center;
      }
      // Add the attachment behavior to the dynamic animator
      [_dynamicAnimator addBehavior: attachmentBehavior];
      // Add the item's index path to the visible index path set
      [_visibleIndexPathsSet addObject: attribute.indexPath];
    }
  ];
}

- (BOOL) shouldInvalidateLayoutForBoundsChange: (CGRect) newBounds
{
  // Asks the layout object if the new bounds require a layout update

  // The collection view this layout belongs to
  UIScrollView *scrollView = self.collectionView;

  // The distance between the new top left corner and the old top left corner
  CGFloat delta = newBounds.origin.y - scrollView.bounds.origin.y;
  _latestDelta = delta;

  // Returns the point computed as the location in a given view 
  // of the gesture represented by the receiver
  CGPoint touchLocation =
    [self.collectionView.panGestureRecognizer locationInView: self.
      collectionView];

  // Update each behavior
  // The dynamic behaviors managed by a dynamic animator
  [_dynamicAnimator.behaviors enumerateObjectsUsingBlock:
    ^(UIAttachmentBehavior *attachmentBehavior, NSUInteger idx, BOOL *stop) {
      CGFloat distanceFromTouch = fabsf(
        touchLocation.y - attachmentBehavior.anchorPoint.y);
      CGFloat scrollResistance = distanceFromTouch / 
        kInformationStepsScrollResistance;

      // attachmentBehavior.items = 
      // The dynamic items connected by the attachment behavior
      UICollectionViewLayoutAttributes *attribute = 
        [attachmentBehavior.items firstObject];
      // The center point of the item
      CGPoint center = attribute.center;
      if (delta < 0)
        center.y += MAX(delta, delta * scrollResistance);
      else
        center.y += MIN(delta, delta * scrollResistance);
      attribute.center = center;
      // Asks a dynamic animator to read the current state of a dynamic item, 
      // replacing the animator’s internal representation of the item’s state
      [_dynamicAnimator updateItemUsingCurrentState: attribute];
    }
  ];

  return NO;
}

@end
