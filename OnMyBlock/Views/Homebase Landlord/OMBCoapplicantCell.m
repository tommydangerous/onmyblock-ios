//
//  OMBCoapplicantCell.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 1/5/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBCoapplicantCell.h"

@implementation OMBCoapplicantCell

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) loadUnregisteredUserData
{
  self.accessoryType = UITableViewCellAccessoryNone;

  objectImageView.image = [UIImage imageNamed: @"user_icon.png"];
  topLabel.text    = @"James Smith";
  middleLabel.text = @"james@gmail.com";
  bottomLabel.text = @"(626) 858-1234"; 
}

- (void) loadUserData
{
  self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

  objectImageView.image = [UIImage imageNamed: @"tommy_d.png"];
  topLabel.text    = @"Tommy Dang";
  middleLabel.text = @"University of California - Berkeley";
  bottomLabel.text = @"";
}

@end
