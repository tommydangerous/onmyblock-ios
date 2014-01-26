//
//  OMBOfferInquiryViewController.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 1/5/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBViewController.h"

#import "PayPalMobile.h"

@class OMBAlertView;
@class OMBCenteredImageView;
@class OMBGradientView;
@class OMBOffer;

@interface OMBOfferInquiryViewController : OMBViewController
<PayPalPaymentDelegate, UIScrollViewDelegate, UITableViewDataSource, 
  UITableViewDelegate>
{
  BOOL accepted;
  BOOL acceptedConfirmed;
  OMBAlertView *alert;
  UIView *backView;
  CGFloat backViewOffsetY;
  UIView *buttonsView;
  BOOL charging;
  BOOL cameFromSettingUpPayoutMethods;
  UIButton *contactButton;
  OMBGradientView *gradient;
  NSArray *legalQuestions;
  OMBOffer *offer;
  UIButton *offerButton;
  int previouslySelectedIndex;
  UIButton *profileButton;
  UIButton *respondButton;
  UIView *respondView;
  int selectedSegmentIndex;
  OMBCenteredImageView *userImageView;
}

#pragma mark - Initializer

- (id) initWithOffer: (OMBOffer *) object;

// Tables
@property (nonatomic, strong) UITableView *offerTableView;
@property (nonatomic, strong) UITableView *profileTableView;

@end
