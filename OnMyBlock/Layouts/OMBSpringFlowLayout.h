//
//  OMBSpringFlowLayout.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 10/24/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OMBSpringFlowLayout : UICollectionViewFlowLayout

@property (nonatomic, strong) UIDynamicAnimator *dynamicAnimator;

// Needed for tiling
@property (nonatomic, assign) UIInterfaceOrientation interfaceOrientation;
@property (nonatomic, assign) CGFloat latestDelta;
@property (nonatomic, strong) NSMutableSet *visibleIndexPathsSet;

@end
