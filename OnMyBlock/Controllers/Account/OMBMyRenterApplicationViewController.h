//
//  OMBMyRenterApplicationViewController.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 1/14/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBTableViewController.h"

@class OMBCenteredImageView;
@class OMBEmployment;
@class OMBUser;

@interface OMBMyRenterApplicationViewController : OMBTableViewController
<UIScrollViewDelegate>
{
  UIView *backView;
  CGFloat backViewOffsetY;
  UIBarButtonItem *editBarButtonItem;
  NSArray *legalQuestions;
  OMBUser *user;
  OMBCenteredImageView *userImageView;
}

#pragma mark - Initializer

- (id) initWithUser: (OMBUser *) object;

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) showCompanyWebsiteWebViewForEmployment: (OMBEmployment *) employment;

@end
