//
//  OMBRenterApplicationViewController.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 11/30/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBTableViewController.h"

@class OMBCenteredImageView;

@interface OMBRenterApplicationViewController : OMBTableViewController
{
  OMBCenteredImageView *userProfileImageView;
}

@property (nonatomic, strong) OMBUser *user;

- (id) initWithUser: (OMBUser *) object;

@end
