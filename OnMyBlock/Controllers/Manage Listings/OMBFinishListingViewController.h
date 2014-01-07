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
@class OMBGradientView;
@class OMBResidence;

@interface OMBFinishListingViewController : OMBTableViewController
<ELCImagePickerControllerDelegate, UIActionSheetDelegate, 
  UINavigationControllerDelegate, UIImagePickerControllerDelegate>
{
  UIView *cameraView;
  CGFloat headerImageOffsetY;
  UIImageView *headerImageView;
  OMBGradientView *headerImageViewGradient;
  int numberOfSteps;
  int numberOfStepsCompleted;
  UIButton *publishNowButton;
  AMBlurView *publishNowView;
  OMBResidence *residence;
  AMBlurView *stepsRemainingView;
  NSMutableArray *stepViews;
}

#pragma mark - Initializer

- (id) initWithResidence: (OMBResidence *) object;

@end
