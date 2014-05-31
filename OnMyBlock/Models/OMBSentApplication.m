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
  NSDateFormatter *dateFormatter = [NSDateFormatter new];
  dateFormatter.dateFormat = @"yyyy-MM-d HH:mm:ss ZZZ";

  // Created at
  id createdAt = [dictionary objectForKey: @"created_at"];
  if (createdAt != [NSNull null])
    self.createdAt = [[dateFormatter dateFromString:
      createdAt] timeIntervalSince1970];

  // Move in date
  id moveInDate = [dictionary objectForKey: @"move_in_date"];
  if (moveInDate != [NSNull null])
    self.moveInDate = [[dateFormatter dateFromString:
      moveInDate] timeIntervalSince1970];

  // Move out date
  id moveOutDate = [dictionary objectForKey: @"move_out_date"];
  if (moveOutDate != [NSNull null])
    self.moveOutDate = [[dateFormatter dateFromString:
      moveOutDate] timeIntervalSince1970];

  // Landlord User ID

  // Renter Application ID

  // Residence ID
  id residenceID = [dictionary objectForKey: @"residence_id"];
  if (residenceID != [NSNull null])
    self.residenceID = [residenceID intValue];
  
  // UID
  id uid = [dictionary objectForKey: @"id"];
  if (uid != [NSNull null])
    self.uid = [uid intValue];
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
