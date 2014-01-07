//
//  OMBMessageDetailCollectionViewFlowLayout.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 12/25/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OMBMessageDetailCollectionViewFlowLayout : UICollectionViewFlowLayout

// Holds all the UIAttachmentBehaviors
@property (nonatomic, strong) UIDynamicAnimator *dynamicAnimator;
@property (nonatomic, assign) UIInterfaceOrientation interfaceOrientation;
@property (nonatomic, assign) CGFloat latestDelta;
// A set of NSIndexPaths for visible cells
@property (nonatomic, strong) NSMutableSet *visibleIndexPathsSet;

@end
