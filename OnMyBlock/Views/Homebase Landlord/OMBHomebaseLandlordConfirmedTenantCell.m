//
//  OMBHomebaseLandlordConfirmedTenantCell.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 1/5/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBHomebaseLandlordConfirmedTenantCell.h"

#import "OMBUser.h"

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

- (void) loadUser: (OMBUser *) object
{
  user = object;

  if (user.image) {
    objectImageView.image = [user imageForSize: objectImageView.bounds.size];
  }
  else {
    [user downloadImageFromImageURLWithCompletion: ^(NSError *error) {
      objectImageView.image = [user imageForSize: 
        objectImageView.bounds.size];
    }];
    objectImageView.image = [UIImage imageNamed: @"user_icon.png"];
  }
  topLabel.text    = [user fullName];
  middleLabel.text = user.school;
  bottomLabel.text = [user phoneString];
}

@end
