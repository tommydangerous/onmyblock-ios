//
//  OMBHomebaseLandlordConfirmedTenantCell.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 1/5/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBImageThreeLabelCell.h"

@class OMBUser;

@interface OMBHomebaseLandlordConfirmedTenantCell : OMBImageThreeLabelCell
{
  OMBUser *user;
}

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) loadUser: (OMBUser *) object;

@end
