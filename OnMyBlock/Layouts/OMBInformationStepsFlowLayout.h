//
//  OMBInformationStepsFlowLayout.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 2/11/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OMBInformationStepsFlowLayout : UICollectionViewFlowLayout

// Holds all the UIAttachmentBehaviors
@property (nonatomic, strong) UIDynamicAnimator *dynamicAnimator;
@property (nonatomic, assign) UIInterfaceOrientation interfaceOrientation;
@property (nonatomic, assign) CGFloat latestDelta;
// A set of NSIndexPaths for visible cells
@property (nonatomic, strong) NSMutableSet *visibleIndexPathsSet;

@end
