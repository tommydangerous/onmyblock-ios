//
//  OMBRoommate.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 3/17/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBRoommate.h"

#import "OMBUser.h"

@implementation OMBRoommate

#pragma mark - Methods

#pragma mark - Class Methods

+ (NSString *) modelName
{
  return @"roommate";
}

+ (NSString *) resourceName
{
  return [NSString stringWithFormat: @"%@s", [OMBRoommate modelName]];
}

#pragma mark - Instance Methods

- (void) readFromDictionary: (NSDictionary *) dictionary
{
  // Email
  id email = [dictionary objectForKey: @"email"];
  if (email != [NSNull null]) {
    self.email = email;
  }

  // First name
  id firstName = [dictionary objectForKey: @"first_name"];
  if (firstName != [NSNull null])
    self.firstName = firstName;

  // Last name
  id lastName = [dictionary objectForKey: @"last_name"];
  if (lastName != [NSNull null])
    self.lastName = lastName;

  // Provider ID
  id providerId = [dictionary objectForKey: @"provider_id"];
  if (providerId != [NSNull null])
    self.providerId = [providerId intValue];

  // Roommate
  id roommate = [dictionary objectForKey: @"roommate"];
  if (roommate != [NSNull null]) {
    self.roommate = [[OMBUser alloc] init];
    [self.roommate readFromDictionary: roommate];
  }

  // User

  // UID
  id uid = [dictionary objectForKey: @"id"];
  if (uid != [NSNull null])
    self.uid = [uid intValue];

  NSLog(@"OMBRoommate:\n%@", dictionary);
}

@end
