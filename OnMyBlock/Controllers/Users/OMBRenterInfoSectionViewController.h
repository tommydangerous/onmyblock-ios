//
//  OMBRenterInfoSectionViewController.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 3/10/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBTableViewController.h"

@class AMBlurView;
@class OMBRenterInfoAddViewController;
@class OMBUser;

@interface OMBRenterInfoSectionViewController : OMBTableViewController
{
  UIButton *addButton;
  OMBRenterInfoAddViewController *addViewController;
  AMBlurView *bottomBlurView;
  UILabel *emptyLabel;
}

#pragma mark - Initializer

- (id) initWithUser: (OMBUser *) object;

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) setEmptyLabelText: (NSString *) string;

@end
