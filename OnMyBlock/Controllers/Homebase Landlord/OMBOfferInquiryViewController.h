//
//  OMBOfferInquiryViewController.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 1/5/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBViewController.h"

@class AMBlurView;
@class OMBCenteredImageView;

@interface OMBOfferInquiryViewController : OMBViewController
<UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate>
{
  BOOL accepted;
  BOOL acceptedConfirmed;
  AMBlurView *alert;
  UIView *alertButtonsView;
  UIButton *alertCancel;
  UIButton *alertConfirm;
  UILabel *alertMessage;
  UILabel *alertTitle;
  UIView *backView;
  CGFloat backViewOffsetY;
  UIView *buttonsView;
  UIButton *contactButton;
  UIView *fadedBackground;
  NSArray *legalQuestions;
  UIButton *offerButton;
  UIButton *profileButton;
  UIButton *respondButton;
  UIView *respondView;
  int selectedSegmentIndex;
  OMBCenteredImageView *userImageView;

  NSString *fakeAbout;
}

@property (nonatomic, strong) UIDynamicAnimator *animator;
@property (nonatomic, strong) UIGravityBehavior *gravityBehavior;
@property (nonatomic, strong) UIDynamicItemBehavior *itemBehavior;
@property (nonatomic, strong) UISnapBehavior *snapBehavior;

#pragma mark - Initializer

- (id) initWithOffer: (NSString *) object;

// Tables
@property (nonatomic, strong) UITableView *offerTableView;
@property (nonatomic, strong) UITableView *profileTableView;

@end
