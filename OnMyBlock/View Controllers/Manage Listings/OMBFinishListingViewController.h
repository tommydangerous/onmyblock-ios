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
@class LEffectLabel;
@class OMBActivityView;
@class OMBAlertViewBlur;
@class OMBCenteredImageView;
@class OMBGradientView;
@class OMBResidence;

@interface OMBFinishListingViewController : OMBTableViewController
<ELCImagePickerControllerDelegate, UIActionSheetDelegate, 
  UINavigationControllerDelegate, UIImagePickerControllerDelegate>
{
  OMBActivityView *activityView;
  OMBAlertViewBlur *alertBlur;
  UIView *cameraView;
  LEffectLabel *effectLabel;
  CGFloat headerImageOffsetY;
  OMBCenteredImageView *headerImageView;
  OMBGradientView *headerImageViewGradient;
  BOOL isPublishing;
  UIBarButtonItem *previewBarButtonItem;
  UIButton *publishNowButton;
  AMBlurView *publishNowView;
  OMBResidence *residence;
  AMBlurView *stepsRemainingView;
  NSMutableArray *stepViews;
  UIBarButtonItem *unlistBarButtonItem;
  UIButton *unlistButton;
  AMBlurView *unlistView;
}

@property (nonatomic) BOOL nextSection;

#pragma mark - Initializer

- (id) initWithResidence: (OMBResidence *) object;
- (void) nextIncompleteSection;
@end
