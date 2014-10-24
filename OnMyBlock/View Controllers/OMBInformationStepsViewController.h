//
//  OMBInformationStepsViewController.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 2/11/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBTableViewController.h"

@interface OMBInformationStepsViewController : OMBTableViewController
<UICollectionViewDataSource, UICollectionViewDelegate, 
  UIGestureRecognizerDelegate, UIScrollViewDelegate>
{
  CGPoint lastPoint;
  UICollectionView *pageCollectionView;
  UIScrollView *scroll;
}

@property (nonatomic, strong) UIDynamicAnimator *animator;
@property (nonatomic, strong) UICollisionBehavior *collisionBehavior;
@property (nonatomic, strong) UIDynamicItemBehavior *elasticityBehavior;
@property (nonatomic, strong) UIGravityBehavior *gravityBehavior;
@property (nonatomic, strong) NSArray *informationArray;
@property (nonatomic, strong) UIDynamicItemBehavior *itemBehavior;
@property (nonatomic, strong) UISnapBehavior *snapBehavior;

#pragma mark - Initializer

- (id) initWithInformationArray: (NSArray *) array;

@end
