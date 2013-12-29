//
//  OMBFinishListingViewController.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 12/27/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBTableViewController.h"

@class OMBGradientView;
@class OMBResidence;

@interface OMBFinishListingViewController : OMBTableViewController
{
  UIView *cameraView;
  CGFloat headerImageOffsetY;
  UIImageView *headerImageView;
  OMBGradientView *headerImageViewGradient;
  OMBResidence *residence;
}

#pragma mark - Initializer

- (id) initWithResidence: (OMBResidence *) object;

@end
