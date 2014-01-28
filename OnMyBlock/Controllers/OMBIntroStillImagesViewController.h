//
//  OMBIntroStillImagesViewController.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 12/12/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBViewController.h"

@class DDPageControl;
@class OMBActivityView;
@class OMBCloseButtonView;
@class OMBGetStartedView;
@class OMBLoginViewController;
@class OMBSignUpView;
@class OMBStudentOrLandlordView;

@interface OMBIntroStillImagesViewController : OMBViewController
<UIScrollViewDelegate>
{
  NSMutableArray *backgroundViewArray;
  UIView *bottomView;
  OMBCloseButtonView *closeButtonView;
  UIButton *loginButton;
  UIButton *signUpButton;
  UIView *skipButtonView;
  NSArray *slides;
  OMBStudentOrLandlordView *studentLandlordView;
}

// Views that do not scroll
@property (nonatomic, strong) OMBActivityView *activityView;
@property (nonatomic, strong) OMBGetStartedView *getStartedView;
@property (nonatomic, strong) DDPageControl *pageControl;
@property (nonatomic, strong) UIScrollView *scroll;
@property (nonatomic, strong) OMBSignUpView *signUpView;

// Controllers
@property (nonatomic, strong) OMBLoginViewController *loginViewController;

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) hideStudentLandlordView;
- (void) resetViews;
- (void) scrollToPage: (int) page;
- (void) setupForLoggedInUser;
- (void) setupForLoggedOutUser;
- (void) showLogin;

@end
