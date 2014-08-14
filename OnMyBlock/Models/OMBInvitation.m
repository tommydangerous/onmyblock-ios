//
//  OMBInvitation.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 8/14/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBInvitation.h"

@implementation OMBInvitation

#pragma mark - Override

#pragma mark - Override OMBObject

- (void)readFromDictionary:(NSDictionary *)dictionary
{
  [super readFromDictionary:dictionary];

  id email = [dictionary objectForKey:@"email"];
  if (email != [NSNull null]) {
    self.email = email;
  }

  id firstName = [dictionary objectForKey:@"first_name"];
  if (firstName != [NSNull null]) {
    self.firstName = firstName;
  }

  id invitableId = [dictionary objectForKey:@"invitable_id"];
  if (invitableId != [NSNull null]) {
    self.invitableId = [invitableId intValue];
  }

  id invitableType = [dictionary objectForKey:@"invitable_type"];
  if (invitableType != [NSNull null]) {
    self.invitableType = invitableType;
  }

  id lastName = [dictionary objectForKey:@"last_name"];
  if (lastName != [NSNull null]) {
    self.lastName = lastName;
  }

  id providerId = [dictionary objectForKey:@"provider_id"];
  if (providerId != [NSNull null]) {
    self.providerId = providerId;
  }

  id userId = [dictionary objectForKey:@"user_id"];
  if (userId != [NSNull null]) {
    self.userId = [userId intValue];
  }
}

@end
