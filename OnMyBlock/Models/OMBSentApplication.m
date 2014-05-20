//
//  OMBSentApplication.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 5/19/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBSentApplication.h"

@implementation OMBSentApplication

#pragma mark - Methods

#pragma mark - Class Methods

+ (NSString *) modelName
{
  return @"sent_application";
}

+ (NSString *) resourceName
{
  return [NSString stringWithFormat: @"%@s", [OMBSentApplication modelName]];
}

#pragma mark - Instance Methods

- (void) readFromDictionary: (NSDictionary *) dictionary
{
  // Sample JSON
  // {
  //   created_at: "2014-05-19 21:36:37 -0700",
  //   id: 38,
  //   move_in_date: "2014-05-19 21:36:37 -0700",
  //   move_out_date: "2014-08-18 21:36:37 -0700",
  //   landlord_user_id: 1420,
  //   renter_application_id: 6,
  //   residence_id: 666,
  //   sent: 1
  // }
}

- (NSString *) modelName
{
  return [OMBSentApplication modelName];
}

- (NSString *) resourceName
{
  return [OMBSentApplication resourceName];
}

@end
