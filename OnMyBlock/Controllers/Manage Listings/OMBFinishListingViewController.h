//
//  OMBFinishListingViewController.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 12/27/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBTableViewController.h"

#import "ELCImagePickerController.h"

@class AMBlurView;
@class OMBCenteredImageView;
@class OMBGradientView;
@class OMBResidence;

@interface OMBFinishListingViewController : OMBTableViewController
<ELCImagePickerControllerDelegate, UIActionSheetDelegate, 
  UINavigationControllerDelegate, UIImagePickerControllerDelegate>
{
  UIView *cameraView;
  CGFloat headerImageOffsetY;
  OMBCenteredImageView *headerImageView;
  OMBGradientView *headerImageViewGradient;
  int numberOfSteps;
  UIButton *publishNowButton;
  AMBlurView *publishNowView;
  OMBResidence *residence;
  AMBlurView *stepsRemainingView;
  NSMutableArray *stepViews;
}

#pragma mark - Initializer

- (id) initWithResidence: (OMBResidence *) object;

@end
