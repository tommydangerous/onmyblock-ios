//
//  OMBHomebaseLandlordConfirmedTenantCell.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 1/5/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBHomebaseLandlordConfirmedTenantCell.h"

@implementation OMBHomebaseLandlordConfirmedTenantCell

#pragma mark - Initializer

- (id) initWithStyle: (UITableViewCellStyle) style 
reuseIdentifier: (NSString *) reuseIdentifier
{
  if (!(self = [super initWithStyle: style reuseIdentifier: reuseIdentifier])) 
    return nil;

  self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

  return self;
}

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) loadUserData
{
  objectImageView.image = [UIImage imageNamed: @"edward_d.jpg"];
  topLabel.text    = @"Edward Drake";
  middleLabel.text = @"University of California - Berkeley";
  bottomLabel.text = @"(408) 858-1234";
}

@end
