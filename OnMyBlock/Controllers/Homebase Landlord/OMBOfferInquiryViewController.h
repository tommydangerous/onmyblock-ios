//
//  OMBOfferInquiryViewController.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 1/5/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBViewController.h"

@class OMBAlertView;
@class OMBCenteredImageView;

@interface OMBOfferInquiryViewController : OMBViewController
<UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate>
{
  BOOL accepted;
  BOOL acceptedConfirmed;
  OMBAlertView *alert;
  UIView *backView;
  CGFloat backViewOffsetY;
  UIView *buttonsView;
  UIButton *contactButton;
  NSArray *legalQuestions;
  UIButton *offerButton;
  UIButton *profileButton;
  UIButton *respondButton;
  UIView *respondView;
  int selectedSegmentIndex;
  OMBCenteredImageView *userImageView;

  NSString *fakeAbout;
}

#pragma mark - Initializer

- (id) initWithOffer: (NSString *) object;

// Tables
@property (nonatomic, strong) UITableView *offerTableView;
@property (nonatomic, strong) UITableView *profileTableView;

@end
