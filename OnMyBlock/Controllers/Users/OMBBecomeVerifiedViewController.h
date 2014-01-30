//
//  OMBBecomeVerifiedViewController.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 1/29/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBViewController.h"

@class AMBlurView;
@class LIALinkedInHttpClient;
@class OMBFacebookButton;
@class OMBLinkedInButton;
@class OMBUser;

typedef NS_ENUM(NSInteger, OMBBecomeVerifiedStep) {
  OMBBecomeVerifiedStepCoapplicants,
  OMBBecomeVerifiedStepCosigners,
  OMBBecomeVerifiedStepAuthentication
};

@interface OMBBecomeVerifiedViewController : OMBViewController
{
  UIView *authenticationView;
  UIView *coapplicantsView;
  UIView *cosignersView;
  OMBFacebookButton *facebookButton;
  UILabel *headerLabel;
  NSArray *headerLabelArray;
  OMBLinkedInButton *linkedInButton;
  LIALinkedInHttpClient *linkedInClient;
  UIButton *nextButton;
  AMBlurView *nextView;
  UIButton *noButton;
  UIView *progressBar;
  UIScrollView *scroll;
  NSInteger stepNumber;
  OMBUser *user;
  UILabel *valueLabel;
  NSMutableDictionary *valueDictionary;
  UIButton *yesButton;
}

#pragma mark - Initializer

- (id) initWithUser: (OMBUser *) object;

@end
